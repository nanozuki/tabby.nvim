---Unique file name helper, return shortest unique name of a file
---At first, it will try to use the file name as the unique name.
---If there are same name items, prepend the parent path to each name.
---@class TabbyNameUniquifier
---@field names table<number, string> map of hanlder to unique name
---@field loader fun():table<number, string> load file names for lazy loading, handler -> name
---@field built boolean whether the unique names are built
local NameUniquifier = {}
NameUniquifier.__index = NameUniquifier

---Create a new NameUniquifier
---@param loader fun():table<number, string> load file names for lazy loading, handler -> name
---@return TabbyNameUniquifier
function NameUniquifier:new(loader)
  local instance = {
    names = {},
    loader = loader,
    built = false,
  } ---@type TabbyNameUniquifier
  setmetatable(instance, NameUniquifier)
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

local function build_uniquifier(u)
  local all_names = u.loader()
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
        u.names[items[1].n] = t_name
      else
        for _, item in ipairs(items) do
          local hh = head(item.h)
          if hh == '.' or hh == '/' then
            u.names[item.n] = t_name
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

---Get the unique name of a handler
---@param handler number
---@return string
function NameUniquifier:get_name(handler)
  if not self.built then
    build_uniquifier(self)
    self.built = true
  end
  return self.names[handler]
end

---Flush the unique names
function NameUniquifier:flush()
  self.names = {}
  self.built = false
end
