---@class TabbyFileNameLoader load names for lazy loading
---@field get_name fun(handler:number):string get name by handler
---@field get_names fun():table<number, string> get all names

---@alias TabbyFileNameMode 'unique'|'relative'|'tail'|'shorten'

---@class TabbyFileNameResolver
---@field private loader TabbyFileNameLoader load names for lazy loading
---@field private uniquified boolean whether the names are uniquified
---@field private uniquified_names table<number, string> cache map of hanlder to name
local FileNameResolver = {}
FileNameResolver.__index = FileNameResolver

---Create a new FileNameResolver
---@param loader TabbyFileNameLoader
---@return TabbyFileNameResolver
function FileNameResolver:new(loader)
  local instance = {
    loader = loader,
    uniquified = false,
    uniquified_names = {},
  } ---@type TabbyFileNameResolver
  setmetatable(instance, FileNameResolver)
  return instance
end

local function relative(name)
  return vim.fn.fnamemodify(name, ':~:.')
end

local function head(name)
  return vim.fn.fnamemodify(name, ':h')
end

local function tail(name)
  return vim.fn.fnamemodify(name, ':t')
end

local function shorten(name)
  return vim.fn.pathshorten(vim.fn.fnamemodify(name, ':~:.'))
end

---@private
function FileNameResolver:uniquify_names()
  local all_names = self.loader()
  local indexes = {} ---@type table<string, {h: string, n:number}>

  for handler, name in pairs(all_names) do
    name = relative(name)
    local t_name = tail(name)
    local h_name = head(name)
    indexes[t_name] = indexes[t_name] or {}
    table.insert(indexes[t_name], { h = h_name, n = handler })
  end

  local next_index = {} ---@type table<string, {h: string, n:number}>
  while #indexes > 0 do
    for t_name, items in pairs(indexes) do
      if #items == 1 then
        self.uniquified_names[items[1].n] = t_name
      else
        for _, item in ipairs(items) do
          local hh = head(item.h)
          if hh == '.' or hh == '/' then
            self.uniquified_names[item.n] = t_name
          else
            local name = table.concat({ tail(item.h), t_name }, '/')
            next_index[name] = next_index[name] or {}
            table.insert(next_index[name], { h = item.h, n = item.n })
          end
        end
      end
    end
    indexes = next_index
    next_index = {}
  end
end

---Get unique name of a handler
---@private
---@param handler number
---@param fallback fun(handler:number):string
---@return string
function FileNameResolver:get_unique_name(handler, fallback)
  if not self.uniquified then
    self:uniquify_names()
    self.uniquified = true
  end
  return self.uniquified_names[handler] or fallback(handler)
end

local transformers = {
  relative = relative,
  tail = tail,
  shorten = shorten,
} ---@type table<'relative'|'tail'|'shorten', fun(string):string>

---Get name of a handler by other mode
---@private
---@param handler number
---@param mode 'relative'|'tail'|'shorten' mode but unique
---@param fallback fun(handler:number):string
---@return string
function FileNameResolver:get_other_name(handler, mode, fallback)
  local name = self.loader(handler)
  if not name then
    name = fallback(handler)
  else
    name = transformers[mode](name)
  end
  return name
end

local default_fallback = function(_)
  return '[No Name]'
end

---Get name of a handler
---@param handler number
---@param mode TabbyFileNameMode
---@param fallback? fun(handler:number):string
---@return string
function FileNameResolver:get_name(handler, mode, fallback)
  fallback = fallback or default_fallback
  if mode == 'unique' then
    return self:get_unique_name(handler, fallback)
  else
    return self:get_other_name(handler, self.mode --[[@as 'relative'|'tail'|'shorten']], fallback)
  end
end

---Flush name caches
function FileNameResolver:flush()
  self.uniquified_names = {}
  self.uniquified = false
end
