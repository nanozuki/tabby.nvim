local tab = {}

---@type TabbyTabProviderFn
---@param tabid number
---@return number
function tab.number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

local function default_tabname(tabid)
  return tabid
end

---@type TabbyTabProviderFn
---@param tabid number
---@return string
function tab.name(tabid, opt)
  local name = vim.api.nvim_tabpage_get_var(tabid, 'tabname')
  if name and name ~= '' then
    return name
  end
  local default_name = ((opt or {})['tab.name'] or {})['default'] or default_tabname
  return default_name(tabid)
end

local TabFilename = {
  tabid = 0,
}
TabFilename.__index = TabFilename

function TabFilename:new(tabid)
  local o = { tabid = tabid }
  setmetatable(o, self)
  return o
end

function TabFilename:unique() end

function tab.filename(tabid)
  local focus_win = vim.api.nvim_tabpage_get_win(tabid)
  local filename = require('tabby.filename')
  local name = filename.unique(focus_win)
  return name
end

return tab
