local buf_name = {}

local filename = require('tabby.module.filename')

---@class TabbyBufNameOption
---@field mode 'unique'|'relative'|'tail'|'shorten' @defult unique

---@type TabbyBufNameOption
local option = {
  mode = 'unique',
}

function buf_name.set_option(opt)
  option = vim.tbl_deep_extend('force', option, opt)
end

function buf_name.get(winid)
  if option.mode == 'unique' then
    return buf_name.get_unique_name(winid)
  elseif option.mode == 'relative' then
    return buf_name.get_relative_name(winid)
  elseif option.mode == 'tail' then
    return buf_name.get_tail_name(winid)
  elseif option.mode == 'shorten' then
    return buf_name.get_shorten_name(winid)
  else
    return ''
  end
end

---@param winid number
---@return string filename
function buf_name.get_unique_name(winid)
  return filename.unique(winid)
end

---@param winid number
---@return string filename
function buf_name.get_relative_name(winid)
  return filename.relative(winid)
end

---@param winid number
---@return string filename
function buf_name.get_tail_name(winid)
  return filename.tail(winid)
end

---@param winid number
---@return string filename
function buf_name.get_shorten_name(winid)
  return filename.shorten(winid)
end

return buf_name
