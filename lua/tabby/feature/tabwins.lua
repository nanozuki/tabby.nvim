local tabwins = {}

local api = require('tabby.module.api')

---@class TabbyTab
---@field id number tabid
---@field current_win fun():TabbyWin current window in this tab
---@field wins fun():TabbyWins windows in this tab
---@field number fun():number return tab number
---@field is_current fun():boolean return if this tab is current tab
---@field name fun():string return tab name
---@field close_btn fun(symbol:string):TabbyNode return close btn

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
  }
end

---@class TabbyTabs
---@field tabs TabbyTab[] tabs
---@field foreach fun(fn:fun(tab:TabbyTab)):TabbyNode render tabs by given render function

local function wrap_tab_node(node, tabid)
  if type(node) == 'string' then
    return { node, click = { 'to_tab', tabid } }
  elseif type(node) == 'table' then
    node.click = { 'to_tab', tabid }
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
    foreach = function(fn)
      local nodes = {}
      for _, tab in ipairs(tabs) do
        local node = fn(tab)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = wrap_tab_node(node, tab.id)
        end
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
      -- require 'kyazdani42/nvim-web-devicons'
      local name = require('tabby.module.filename').tail(winid)
      local extension = vim.fn.fnamemodify(name, ':e')
      local icon = require('nvim-web-devicons').get_icon(name, extension)
      return icon
    end,
    buf_name = function()
      return require('tabby.feature.buf_name').get(winid, opt.buf_name)
    end,
  }
end

---@class TabbyWins
---@field wins TabbyWin[] windows
---@field foreach fun(fn:fun(win:TabbyWin)):TabbyNode render wins by given render function

---new win object
---@param win_ids number[] win id list
---@param opt TabbyLineOption
---@return TabbyWins
function tabwins.new_wins(win_ids, opt)
  local wins = vim.tbl_map(function(winid)
    return tabwins.new_win(winid, opt)
  end, win_ids)
  return {
    wins = wins,
    foreach = function(fn)
      local nodes = {}
      for _, win in ipairs(wins) do
        local node = fn(win)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = node
        end
      end
      return nodes
    end,
  }
end

---@class TabbyBuf
---@field id number buffer id
---@field type fun():string return buffer type

---new buf object
---@param bufid any
---@return table
function tabwins.new_buf(bufid)
  return {
    id = bufid,
    type = function()
      return api.get_buf_type(bufid)
    end,
  }
end

return tabwins
