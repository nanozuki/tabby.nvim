local tab = {}
local util = require('tabby.util')

---@alias TabNodeFn fun(tabid:number):Node

---@class TabList:number[]
---@field foreach fun(fn:TabNodeFn) give a node function for tab

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
function tab.get_current()
  return vim.api.nvim_get_current_tabpage()
end

---return current win id of the tab
---@param tabid number
---@return number tab id for current tab
function tab.get_current_win(tabid)
  return vim.api.nvim_tabpage_get_win(tabid)
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

---get tab's name
---@param tabid number
---@return string
function tab.get_name(tabid)
  return util.get_tab_name(tabid) -- TODO: remove from util
end

---return tab's close button
---@param tabid number
---@param symbol string
---@param hl Highlight
---@return Node
function tab.close_btn(tabid, symbol, hl)
  return {
    symbol,
    hl = hl,
    click = { 'x_tab', tabid },
  }
end

return tab
