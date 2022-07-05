local win = {}
local filename = require('tabby.filename')

---return if the window in current tab
---@param winid number
---@return boolean
function win.in_current_tab(winid)
  return vim.api.nvim_win_get_tabpage(winid) == vim.api.nvim_get_current_tabpage()
end

---return if the window is current window
---@param winid number
---@return boolean
function win.is_current(winid)
  return winid == vim.api.nvim_tabpage_get_win(vim.api.nvim_get_current_tabpage())
end

---get win's filename
---@param winid number
---@return string
function win.get_filename(winid)
  -- TODO remove from uitl
  -- TODO configure filename pattern
  return filename.unique(winid)
end

---@alias WinNodeFn fun(winid:number):TabbyNode

---@class WinList:number[]
---@field foreach fun(fn:WinNodeFn) give a node function for win

---wrap methods to raw winlist
---@param wins number[]
---@return WinList
local function wrap_win_list(wins)
  local m_index = {
    foreach = function(fn)
      local nodes = {}
      for _, winid in ipairs(wins) do
        local node = fn(winid)
        if node ~= nil then
          nodes[#nodes + 1] = node
        end
      end
      return nodes
    end,
  }
  setmetatable(wins, { __index = m_index })
  return wins
end

---list all win id
---@return WinList
function win.list()
  local wins = vim.api.nvim_list_wins()
  wins = vim.tbl_filter(function(winid)
    return vim.api.nvim_win_get_config(winid).relative == ''
  end, wins)
  return wrap_win_list(wins)
end

---list all win id in a tab
---@param tabid number
---@return WinList
function win.all_in_tab(tabid)
  local wins = vim.api.nvim_tabpage_list_wins(tabid)
  wins = vim.tbl_filter(function(winid)
    return vim.api.nvim_win_get_config(winid).relative == ''
  end, wins)
  return wrap_win_list(wins)
end

return win
