local buf_name = {}

local filename = require('tabby.module.filename')

---@class TabbyBufNameOption
---@field mode 'unique'|'relative'|'tail'|'shorten' @defult unique

---@type TabbyBufNameOption
local default_option = {
  mode = 'unique',
}

function buf_name.set_default_option(opt)
  default_option = vim.tbl_deep_extend('force', default_option, opt)
end

---get buf name
---@param winid number
---@param opt? TabbyBufNameOption
---@return string
function buf_name.get(winid, opt)
  local o = default_option
  if opt ~= nil then
    o = vim.tbl_deep_extend('force', default_option, opt)
  end
  if o.mode == 'unique' then
    return buf_name.get_unique_name(winid)
  elseif o.mode == 'relative' then
    return buf_name.get_relative_name(winid)
  elseif o.mode == 'tail' then
    return buf_name.get_tail_name(winid)
  elseif o.mode == 'shorten' then
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
