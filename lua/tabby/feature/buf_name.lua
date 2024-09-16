local buf_name = {}

local filename = require('tabby.module.filename')

---@class TabbyBufNameOption
---@field mode 'unique'|'relative'|'tail'|'shorten' @default unique
---@field placeholder string @default '[No Name]'
---@field override fun(bufid:number):string?

---@type TabbyBufNameOption
local default_option = {
  mode = 'unique',
  placeholder = '[No Name]',
  override = function()
    return nil
  end,
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
  local bufid = vim.api.nvim_win_get_buf(winid)
  local override = o.override(bufid)
  if override ~= nil then
    return override
  end
  if o.mode == 'unique' then
    return buf_name.get_unique_name(winid, o.placeholder)
  elseif o.mode == 'relative' then
    return buf_name.get_relative_name(winid, o.placeholder)
  elseif o.mode == 'tail' then
    return buf_name.get_tail_name(winid, o.placeholder)
  elseif o.mode == 'shorten' then
    return buf_name.get_shorten_name(winid, o.placeholder)
  else
    return ''
  end
end

---@param winid number
---@param placeholder string?
---@return string filename
function buf_name.get_unique_name(winid, placeholder)
  return filename.unique(winid, placeholder)
end

---@param winid number
---@param placeholder string?
---@return string filename
function buf_name.get_relative_name(winid, placeholder)
  return filename.relative(winid, placeholder)
end

---@param winid number
---@param placeholder string?
---@return string filename
function buf_name.get_tail_name(winid, placeholder)
  return filename.tail(winid, placeholder)
end

---@param winid number
---@param placeholder string?
---@return string filename
function buf_name.get_shorten_name(winid, placeholder)
  return filename.shorten(winid, placeholder)
end

return buf_name
