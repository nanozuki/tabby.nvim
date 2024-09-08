local tabwins = {}

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
function tabwins.new_tab(tabid, opt)
  return {
    id = tabid,
    current_win = function()
      return tabwins.new_win(api.get_tab_current_win(tabid), opt)
    end,
    wins = function()
      return tabwins.new_wins(api.get_tab_wins(tabid), opt)
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

---@class TabbyTabs
---@field tabs TabbyTab[] tabs
---@field foreach fun(fn:fun(tab:TabbyTab,i:number,n:number):TabbyNode,props:TabbyNode):TabbyNode render tabs by given render function

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
---@param opt TabbyLineOption
---@return TabbyTabs
function tabwins.new_tabs(opt)
  local tabs = vim.tbl_map(function(tabid)
    return tabwins.new_tab(tabid, opt)
  end, api.get_tabs())
  return {
    tabs = tabs,
    foreach = function(fn, props)
      local nodes = {}
      for i, tab in ipairs(tabs) do
        local node = fn(tab, i, #tabs)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = wrap_tab_node(node, tab.id)
        end
      end
      if props ~= nil then
        nodes = vim.tbl_extend('keep', nodes, props)
      end
      return nodes
    end,
  }
end

---@class TabbyWin
---@field id number winid
---@field tab fun():TabbyTab return tab this window belonged
---@field buf fun():TabbyBuf return the buf of this window
---@field is_current fun():boolean return if this window is current window
---@field file_icon fun():string? file icon, require devicons
---@field buf_name fun():string file name

---new TabbyWin
---@param winid number
---@param opt TabbyLineOption
---@return TabbyWin
function tabwins.new_win(winid, opt)
  return {
    id = winid,
    tab = function()
      return tabwins.new_tab(api.get_win_tab(winid), opt)
    end,
    buf = function()
      return tabwins.new_buf(api.get_win_buf(winid))
    end,
    is_current = function()
      return api.get_tab_current_win(api.get_win_tab(winid)) == winid
    end,
    file_icon = function()
      if vim.fn.isdirectory(vim.api.nvim_buf_get_name(vim.api.nvim_win_get_buf(winid))) == 1 then
        return ''
      end
      -- require 'kyazdani42/nvim-web-devicons'
      local name = require('tabby.module.filename').tail(winid)
      local extension = vim.fn.fnamemodify(name, ':e')
      local icon = require('nvim-web-devicons').get_icon(name, extension, { default = true })
      return icon
    end,
    buf_name = function()
      return require('tabby.feature.buf_name').get(winid, opt.buf_name)
    end,
  }
end

---@class TabbyWins
---@field wins TabbyWin[] windows
---@field foreach fun(fn:fun(win:TabbyWin,i:number,n:number):TabbyNode,props:TabbyNode):TabbyNode render wins by given render function

---@alias WinFilter fun(win:TabbyWin):boolean filter for window

---new win object
---@param win_ids number[] win id list
---@param opt TabbyLineOption
---@param ... WinFilter
---@return TabbyWins
function tabwins.new_wins(win_ids, opt, ...)
  local wins = vim.tbl_map(function(winid)
    return tabwins.new_win(winid, opt)
  end, win_ids)
  for _, filter in ipairs({ ... }) do
    wins = vim.tbl_filter(filter, wins)
  end
  return {
    wins = wins,
    foreach = function(fn, props)
      local nodes = {}
      for i, win in ipairs(wins) do
        local node = fn(win, i, #wins)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = node
        end
      end
      if props ~= nil then
        nodes = vim.tbl_extend('keep', nodes, props)
      end
      return nodes
    end,
  }
end

---@class TabbyBuf
---@field id number buffer id
---@field is_changed fun():boolean return if buffer is changed
---@field type fun():string return buffer type

---new buf object
---@param bufid any
---@return table
function tabwins.new_buf(bufid)
  return {
    id = bufid,
    is_changed = function()
      return api.get_buf_is_changed(bufid)
    end,
    type = function()
      return api.get_buf_type(bufid)
    end,
  }
end

function tabwins.new_bufs(opt, ...)
  local bufs = vim.tbl_map(function(bufid)
    return tabwins.new_buf(bufid)
  end, api.get_bufs())
  for _, filter in ipairs({ ... }) do
    bufs = vim.tbl_filter(filter, bufs)
  end
  return {
    bufs = bufs,
    foreach = function(fn)
      local nodes = {}
      for _, buf in ipairs(bufs) do
        local node = fn(buf)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = node
        end
      end
      return nodes
    end,
  }
end

return tabwins
