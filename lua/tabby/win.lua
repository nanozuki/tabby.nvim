local filename = require('tabby.filename')

local win = {}

win.filename = setmetatable({
  ---return relative filename of window
  ---@param winid number
  ---@return string
  relative = function(winid)
    filename.relative(winid)
  end,
  ---return shorten filename of window
  ---@param winid number
  ---@return string
  shorten = function(winid)
    filename.shorten(winid)
  end,
  ---return base filename of window
  ---@param winid number
  ---@return string
  tail = function(winid)
    filename.tail(winid)
  end,
  ---return unique filename of window
  ---@param winid number
  ---@return string
  unique = win.filename,
}, {
  ---return unique filename of window
  ---@param winid number
  ---@return string
  __call = function(winid)
    return filename.unique(winid)
  end,
})

function win.fileicon(winid)
  local devicons = require('nvim-web-devicons')
  if not devicons.has_loaded() then
    devicons.setup({})
  end
  local name = win.filename.tail(winid)
  local ext = vim.fn.fnamemodify(name, ':e')
  return devicons.get_icon(name, ext)
end

local default_modified_icon = ''
local default_read_only_icon = ''

local function modified_icon(winid, icon)
  local bufid = vim.api.nvim_win_get_buf(winid)
  local modified = vim.api.nvim_buf_get_option(bufid, 'modified')
  if modified then
    return icon or default_modified_icon
  end
  return ''
end

win.modified = setmetatable({
  icon = function(icon)
    return function(winid)
      return modified_icon(winid, icon)
    end
  end,
}, {
  __call = function(winid)
    return modified_icon(winid)
  end,
})

win.read_only = setmetatable({
  icon = function(icon)
    return function(winid)
      return win.read_only(winid, icon)
    end
  end,
}, {
  __call = function(winid, icon)
    local bufid = vim.api.nvim_win_get_buf(winid)
    local modifiable = vim.api.nvim_buf_get_option(bufid, 'modifiable')
    if modifiable then
      return icon or default_read_only_icon
    end
    return ''
  end,
})

return win
