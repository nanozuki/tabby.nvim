local M = {}
local api = require('tabby.module.api')

---@class TabbyWin
---@field id number winid
---@field tab fun():TabbyTab return tab this window belonged
---@field buf fun():TabbyBuf return the buf of this window
---@field is_current fun():boolean return if this window is current window
---@field file_icon fun():string file icon, require devicons
---@field buf_name fun():string file name

---new TabbyWin
---@param winid number
---@param opt TabbyLineOption
---@return TabbyWin
function M.new_win(winid, opt)
  return {
    id = winid,
    tab = function()
      return require('tabby.feature.tabs').new_tab(api.get_win_tab(winid), opt)
    end,
    buf = function()
      return require('tabby.feature.bufs').new_buf(api.get_win_buf(winid), opt)
    end,
    is_current = function()
      return api.get_tab_current_win(api.get_win_tab(winid)) == winid
    end,
    file_icon = function()
      return require('tabby.feature.bufs').buf_icon(vim.api.nvim_win_get_buf(winid))
    end,
    buf_name = function()
      return require('tabby.feature.win_name').get(winid, opt.buf_name)
    end,
  }
end

---@alias TabbyWinFilter fun(win:TabbyWin):boolean
---@alias TabbyWinIterator fun(win:TabbyWin,i:number?,total:number?):TabbyNode
---@class TabbyWins
---@field wins TabbyWin[] wins
---@field filter fun(fn:TabbyWinFilter):TabbyWins filter wins, keep the truely value
---@field foreach fun(it:TabbyWinIterator,attrs:TabbyAttrs?):TabbyNode[] render wins by given render function

---new TabbyWins
---@param wins TabbyWin[] win id list
---@param opt TabbyLineOption
---@return TabbyWins
function M.new_wins(wins, opt)
  local obj = { ---@type TabbyWins
    wins = wins,
    filter = function(filter)
      local filtered = vim.tbl_filter(filter, wins)
      return M.new_wins(filtered, opt)
    end,
    foreach = function(fn, attrs)
      local nodes = {}
      for i, win in ipairs(wins) do
        local node = fn(win, i, #wins)
        if node ~= nil and node ~= '' then
          nodes[#nodes + 1] = node
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
