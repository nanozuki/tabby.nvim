local util = require('tabby.util')

local filename = {}

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

---unique buffer name helper
local unique_names = {
  names = nil, ---@type table<number, string>
  indexes = {}, ---@type table<string, any[]>
}

function unique_names:init()
  self.names = nil
end

---@param bufid number
---@param t_name string
---@param h_name string
function unique_names:insert_index(bufid, t_name, h_name)
  if self.indexes[t_name] then
    table.insert(self.indexes[t_name], { h = h_name, n = bufid })
  else
    self.indexes[t_name] = { { h = h_name, n = bufid } }
  end
end

---@param t_name string
function unique_names:clear_index(t_name)
  self.indexes[t_name] = {}
end

---@param bufid number
---@param name string
function unique_names:set(bufid, name)
  self.names[bufid] = name
end

local debug = false

function unique_names:log_index()
  if not debug then
    return
  end
  print('>> unique_names.indexes')
  for t_name, items in pairs(self.indexes) do
    if #items > 0 then
      for i, item in ipairs(items) do
        if i == 1 then
          print(string.format('%s: %s - %d', t_name, item.h, item.n))
        else
          print(string.format('    * %s - %d', item.h, item.n))
        end
      end
    end
  end
end

function unique_names:update_index()
  self:log_index()
  local has_dup = false
  local count = 0
  for t_name, items in pairs(self.indexes) do
    if #items == 1 then
      self:set(items[1].n, t_name)
      self:clear_index(t_name)
      count = count + 1
    elseif #items > 1 then
      for _, item in ipairs(items) do
        local h = vim.fn.fnamemodify(item.h, ':h')
        if h == '.' or h == '/' then -- at root
          self:set(item.n, table.concat({ item.h, t_name }, '/'))
        else
          self:insert_index(item.n, table.concat({ tail(item.h), t_name }, '/'), head(item.h))
        end
      end
      has_dup = true
      self:clear_index(t_name)
      count = count + 1
    end
  end
  return not has_dup or count == 0
end

function unique_names:build()
  self.indexes = {}
  self.names = {}

  local wins = util.list_wins()
  local buffer_ids = {}
  for _, winid in ipairs(wins) do
    local bufid = vim.api.nvim_win_get_buf(winid)
    if buffer_ids[bufid] == nil then
      buffer_ids[bufid] = {}
      local name = relative(vim.api.nvim_buf_get_name(bufid))
      self:insert_index(bufid, tail(name), head(name))
    end
  end

  local complete = false
  while not complete do
    complete = self:update_index()
  end
end

---@param bufid number
---@return string
function unique_names:get_name(bufid)
  if self.names == nil then
    self:build()
  end
  return self.names[bufid]
end

function filename.flush_unique_name_cache()
  unique_names:init()
end

local function wrap_name(name)
  if (name or '') == '' then
    return '[No Name]'
  end
  return name
end

---@param winid number
---@return string filename
function filename.relative(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local fname = vim.api.nvim_buf_get_name(bufid)
  return wrap_name(relative(fname))
end

---@param winid number
---@return string filename
function filename.tail(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local fname = vim.api.nvim_buf_get_name(bufid)
  return wrap_name(tail(fname))
end

---@param winid number
---@return string filename
function filename.shorten(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local fname = vim.api.nvim_buf_get_name(bufid)
  return wrap_name(shorten(fname))
end

---@param winid number
---@return string filename
function filename.unique(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  return wrap_name(unique_names:get_name(bufid))
end

return filename
