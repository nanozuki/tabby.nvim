local buf_name = {}

local filename = require('tabby.module.filename')

---@class TabbyBufNameOption
---@field mode 'unique'|'relative'|'tail'|'shorten' @default unique

---@type TabbyBufNameOption
local default_option = {
  mode = 'unique',
}

function buf_name.set_default_option(opt)
  default_option = vim.tbl_deep_extend('force', default_option, opt)
end

---get buf name
---@param bufid number
---@param opt? TabbyBufNameOption
---@param use_bufs boolean
---@return string
function buf_name.get(bufid, opt, use_bufs)
  local o = default_option
  if opt ~= nil then
    o = vim.tbl_deep_extend('force', default_option, opt)
  end
  if o.mode == 'unique' then
    return buf_name.get_unique_name(bufid, use_bufs)
  elseif o.mode == 'relative' then
    return buf_name.get_relative_name(bufid)
  elseif o.mode == 'tail' then
    return buf_name.get_tail_name(bufid)
  elseif o.mode == 'shorten' then
    return buf_name.get_shorten_name(bufid)
  else
    return ''
  end
end

---@param bufid number
---@param use_bufs boolean
---@return string filename
function buf_name.get_unique_name(bufid, use_bufs)
  return filename.unique(bufid, use_bufs)
end

---@param bufid number
---@return string filename
function buf_name.get_relative_name(bufid)
  return filename.relative(bufid)
end

---@param bufid number
---@return string filename
function buf_name.get_tail_name(bufid)
  return filename.tail(bufid)
end

---@param bufid number
---@return string filename
function buf_name.get_shorten_name(bufid)
  return filename.shorten(bufid)
end

return buf_name
