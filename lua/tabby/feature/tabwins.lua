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
---@return TabbyTab
function tabwins.new_tab(tabid)
  return {
    id = tabid,
    current_win = function()
      return tabwins.new_win(api.get_tab_current_win(tabid))
    end,
    wins = function()
      return tabwins.new_wins(api.get_tab_wins(tabid))
    end,
    number = function()
      return api.get_tab_number(tabid)
    end,
    is_current = function()
      return tabid == api.get_current_tab()
    end,
    name = function()
      return require('tabby.tab').get_name(tabid)
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

---new TabbyTabs
---@return TabbyTabs
function tabwins.new_tabs()
  local tabs = vim.tbl_map(tabwins.new_tab, api.get_tabs())
  return {
    tabs = tabs,
    foreach = function(fn)
      local nodes = {}
      for _, tab in ipairs(tabs) do
        local node = fn(tab)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = node
        end
      end
      return nodes
    end,
  }
end

---@class TabbyWin
---@field id number winid
---@field tab fun():TabbyTab return tab this window belonged
---@field is_current fun():boolean return if this window is current window
---@field file_icon fun():string? file icon, require devicons
---@field buf_name fun():string file name

---new TabbyWin
---@param winid number
---@return TabbyWin
function tabwins.new_win(winid)
  return {
    id = winid,
    tab = function()
      return tabwins.new_tab(api.get_win_tab(winid))
    end,
    is_current = function()
      return winid == vim.api.nvim_tabpage_get_win(winid)
    end,
    file_icon = function()
      -- require 'kyazdani42/nvim-web-devicons'
      local name = require('tabby.module.filename').tail(winid)
      local extension = vim.fn.fnamemodify(name, ':e')
      local icon = require('nvim-web-devicons').get_icon(name, extension)
      return icon
    end,
    buf_name = function()
      require('tabby.features.buf_name').get(winid)
    end,
  }
end

---@class TabbyWins
---@field wins TabbyWin[] windows
---@field foreach fun(fn:fun(tab:TabbyWin)):TabbyNode render wins by given render function

---new win object
---@param win_ids number[] win id list
---@return TabbyWins
function tabwins.new_wins(win_ids)
  local wins = vim.tbl_map(tabwins.new_win, win_ids)
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

return tabwins
