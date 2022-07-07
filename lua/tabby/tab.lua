local tab = {}
local highlight = require('tabby.module.highlight')
local win = require('tabby.win')

---@class TabbyTabOption
---@field name_fallback fun(tabid:number):string

---@type TabbyTabOption
local option = {
  name_fallback = function(tabid)
    local wins = win.all_in_tab(tabid)
    local focus_win = tab.get_current_win(tabid)
    local name = ''
    if vim.api.nvim_win_get_config(focus_win).relative ~= '' then
      name = '[Floating]'
    else
      name = win.get_bufname(focus_win)
    end
    if #wins > 1 then
      name = string.format('%s[%d+]', name, #wins - 1)
    end
    return name
  end,
}

---set tab option
---@param opt TabbyTabOption
function tab.set_option(opt)
  option = vim.tbl_deep_extend('force', option, opt)
end

---@alias TabNodeFn fun(tabid:number):TabbyNode

---@class TabList:number[]
---@field foreach fun(fn:TabNodeFn):TabbyNode give a node function for tab

---wrap methods to raw winlist
---@param tabs number[]
---@return TabList
local function wrap_tab_list(tabs)
  local m_index = {
    foreach = function(fn)
      local nodes = {}
      for _, tabid in ipairs(tabs) do
        local node = fn(tabid)
        if node ~= nil then
          nodes[#nodes + 1] = node
        end
      end
      return nodes
    end,
  }
  setmetatable(tabs, { __index = m_index })
  return tabs
end

---list all tab id
---@return TabList
function tab.all()
  local tabs = vim.api.nvim_list_tabpages()
  return wrap_tab_list(tabs)
end

---return tab id of current tab
---@return number tabid
function tab.get_current_tab()
  return vim.api.nvim_get_current_tabpage()
end

---return current win id of the tab
---@param tabid number
---@return number tab id for current tab
function tab.get_current_win(tabid)
  return vim.api.nvim_tabpage_get_win(tabid)
end

---return all wins in tab
---@param tabid number
---@return WinList
function tab.all_wins(tabid)
  return win.all_in_tab(tabid)
end

---return if this tab is current tab
---@param tabid number
---@return boolean
function tab.is_current(tabid)
  return tabid == vim.api.nvim_get_current_tabpage()
end

---get tab's number, aka index in tabline
---@param tabid any
---@return number
function tab.get_number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

local tab_name_var = 'tabby_tab_name'

---set current tab name
---@param name string
function tab.set_current_name(name)
  vim.api.nvim_tabpage_set_var(0, tab_name_var, name)
end

---set tab name
---@param tabid number
---@param name string
function tab.set_name(tabid, name)
  vim.api.nvim_tabpage_set_var(tabid, tab_name_var, name)
end

---get tab's name
---@param tabid number
---@return string
function tab.get_name(tabid)
  local ok, result = pcall(vim.api.nvim_tabpage_get_var, tabid, tab_name_var)
  if ok then
    return result
  end
  return option.name_fallback(tabid)
end

---get tab's raw name
---@param tabid number
---@return string
function tab.get_raw_name(tabid)
  local ok, result = pcall(vim.api.nvim_tabpage_get_var, tabid, tab_name_var)
  if not ok then
    return ''
  end
  return result
end

---return tab's close button
---@param tabid number
---@param symbol string
---@param current TabbyHighlight
---@param parent TabbyHighlight
---@return TabbyNode
function tab.close_btn(tabid, symbol, current, parent)
  if type(current) == 'string' then
    current = highlight.extract(current)
  end
  if type(parent) == 'string' then
    parent = highlight.extract(parent)
  end
  return {
    symbol,
    hl = { fg = current.fg, bg = parent.bg },
    click = { 'x_tab', tabid },
  }
end

return tab
