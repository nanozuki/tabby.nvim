local M = {}

local api = require('tabby.module.api')
local tab_jumper = require('tabby.feature.tab_jumper')

---@class TabbyTab
---@field id number tabid
---@field current_win fun():TabbyWin current window in this tab
---@field wins fun():TabbyWins windows in this tab
---@field number fun():number return tab number
---@field is_current fun():boolean return if this tab is current tab
---@field name fun():string return tab name
---@field close_btn fun(symbol:string):TabbyNode return close btn
---@field in_jump_mode fun():boolean return if tab is in jump mode
---@field jump_key fun():TabbyNode return jumper

---new TabbyTab
---@param tabid number
---@param opt TabbyLineOption
---@return TabbyTab
function M.new_tab(tabid, opt)
  return {
    id = tabid,
    current_win = function()
      return require('tabby.feature.wins').new_win(api.get_tab_current_win(tabid), opt)
    end,
    wins = function()
      return require('tabby.feature.wins').new_wins(api.get_tab_wins(tabid), opt)
    end,
    number = function()
      return api.get_tab_number(tabid)
    end,
    is_current = function()
      return tabid == api.get_current_tab()
    end,
    name = function()
      return require('tabby.feature.tab_name').get(tabid, opt.tab_name)
    end,
    close_btn = function(symbol)
      -- When there are only one tabpage, the colsed button is disabled by nvim
      local tabs = api.get_tabs()
      if #tabs == 1 then
        return ''
      end
      if type(symbol) == 'string' then
        return { symbol, click = { 'x_tab', tabid } }
      elseif type(symbol) == 'table' then
        symbol.click = { 'x_tab', tabid }
        return symbol
      else
        return ''
      end
    end,
    in_jump_mode = function()
      return tab_jumper.is_start
    end,
    jump_key = function()
      if tab_jumper.is_start then
        return tab_jumper.get_char(tabid)
      end
      return ''
    end,
  }
end

---@alias TabbyTabFilter fun(tab:TabbyTab):boolean
---@alias TabbyTabIterator fun(tab:TabbyTab,i:number?,total:number?):TabbyNode
---@class TabbyTabs
---@field tabs TabbyTab[] tabs
---@field filter fun(fn:TabbyTabFilter):TabbyTabs filter tabs, keep the truely value
---@field foreach fun(it:TabbyTabIterator,attrs:TabbyAttrs?):TabbyNode render tabs by given render function

local function wrap_tab_node(node, tabid)
  if type(node) == 'string' then
    return { node, click = { 'to_tab', tabid } }
  elseif type(node) == 'table' then
    if node.click == nil then
      node.click = { 'to_tab', tabid }
    end
    return node
  else
    return ''
  end
end

---new TabbyTabs
---@param tabs TabbyTab[]
---@param opt TabbyLineOption
---@return TabbyTabs
function M.new_tabs(tabs, opt)
  local obj = {
    tabs = tabs,
    filter = function(filter)
      local filtered = vim.tbl_filter(filter, tabs)
      return M.new_tabs(filtered, opt)
    end,
    foreach = function(fn, attrs)
      local nodes = {}
      for i, tab in ipairs(tabs) do
        local node = fn(tab, i, #tabs)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = wrap_tab_node(node, tab.id)
        end
      end
      if attrs ~= nil then
        nodes = vim.tbl_extend('keep', nodes, attrs)
      end
      return nodes
    end,
  }
  return obj
end

return M
