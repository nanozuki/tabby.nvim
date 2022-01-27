local filename = require('tabby.filename')
local opts = require('tabby.provider.opts')

local win = {
  opt = {
    unique = 'unique',
    shorten = 'shorten',
    relative = 'relative',
    tail = 'tail',
  },
}

---@class TabbyFilenameOpt
---@field mode "unique"|"shorten"|"relative"|"tail"
---@field placeholder string default is '[No Name]'

---return filename with winid
---@param winid number
---@return string filename
function win.filename(winid)
  local opt = opts.win.filename
  if opt.mode == 'unique' then
    filename.unique(winid)
  elseif opt.mode == 'relative' then
    filename.relative(winid)
  elseif opt.mode == 'shorten' then
    filename.shorten(winid)
  elseif opt.mode == 'tail' then
    filename.tail(winid)
  else
    error(string.format("unknown filename mode: '%s'", opt.mode))
  end
end

---window file icon
---@param winid any
---@return string
function win.fileicon(winid)
  local devicons = require('nvim-web-devicons')
  if not devicons.has_loaded() then
    devicons.setup({})
  end
  local name = win.filename.tail(winid)
  local ext = vim.fn.fnamemodify(name, ':e')
  return devicons.get_icon(name, ext)
end

---@class TabbyWinModifiedOpt
---@field icon string

---return an icon when file is modified
---@param winid number
---@return string
function win.modified(winid)
  local opt = opts.win.modified
  local bufid = vim.api.nvim_win_get_buf(winid)
  local modified = vim.api.nvim_buf_get_option(bufid, 'modified')
  if modified then
    return opt.icon
  end
  return ''
end

---@class TabbyWinReadOnlyOpt
---@field icon string

---return an icon when file is read_only
---@param winid number
---@return string
function win.read_only(winid)
  local opt = opts.win.read_only
  local bufid = vim.api.nvim_win_get_buf(winid)
  local modifiable = vim.api.nvim_buf_get_option(bufid, 'modifiable')
  if modifiable then
    return opt.icon
  end
  return ''
end

return win
