---@deprecated
local win = {}

local api = require('tabby.module.api')
local buf_name = require('tabby.feature.buf_name')

---@class TabbyWinOption
---@field bufname_mode 'unique'|'relative'|'tail'|'shorten' @default unique

---set win option
---@param opt TabbyWinOption
function win.set_option(opt)
  buf_name.set_default_option({ mode = opt.bufname_mode })
end

---return if the window in current tab
---@deprecated use: require('tabby.module.api').get_win_tab(winid) == require('tabby.module.api').get_current_tab()
---@param winid number
---@return boolean
function win.in_current_tab(winid)
  return api.get_win_tab(winid) == api.get_current_tab()
end

---return if the window is current window
---@deprecated use: winid == require('tabby.module.api').get_tab_current_win(api.get_current_tab()), or win.is_current()
---@param winid number
---@return boolean
function win.is_current(winid)
  return winid == api.get_tab_current_win(api.get_current_tab())
end

---get win's buffer name
---@deprecated use require('tabby.feature.buf_name').get(winid)
---@param winid number
---@return string bufname
function win.get_bufname(winid)
  local bufid = vim.api.nvim_win_get_buf(winid)
  return buf_name.get(bufid)
end

---list all win id
---@deprecated use require('tabby.module.api').get_wins
---@return number[]
function win.all()
  return api.get_wins()
end

---list all win id in a tab
---@deprecated use require('tabby.module.api').get_tab_wins
---@param tabid number
---@return number[]
function win.all_in_tab(tabid)
  return api.get_tab_wins(tabid)
end

return win
