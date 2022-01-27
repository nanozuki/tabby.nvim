local api = {}

api.win = {}

---check if window is relative
---@param winid number
---@return boolean
function api.win.is_relative(winid)
  return vim.api.nvim_win_get_config(winid).relative ~= ''
end

api.tab = {}

---list all fixed wins of tab
---@param tabid number
---@return number[] array of window id
function api.tab.list_wins(tabid)
  local winids = vim.api.nvim_tabpage_list_wins(tabid)
  return vim.tbl_filter(function(winid)
    return not api.win.is_relative(winid)
  end, winids)
end

function api.tab.get_focus_win(tabid)
  return vim.api.nvim_tabpage_get_win(tabid)
end

local tabname_key = 'tabname'

---set tab name
---@param tabid number
---@param name string
function api.tab.set_name(tabid, name)
  vim.api.nvim_tabpage_set_var(tabid, tabname_key, name)
end

---get tab name
---@param tabid number
---@return string
function api.tab.get_name(tabid)
  local ok, result = pcall(vim.api.nvim_tabpage_get_var, tabid, tabname_key)
  if not ok then
    return nil
  end
  return result
end

---get tab number
---@param tabid number
---@return number
function api.tab.get_number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

return api
