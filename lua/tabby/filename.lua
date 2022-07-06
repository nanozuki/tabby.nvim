local M = {}

local filename = require('tabby.module.filename')

---@deprecated use require('tabby.module.filename').relative
---@param winid number
---@return string filename
function M.relative(winid)
  return filename.relative(winid)
end

---@deprecated use require('tabby.module.filename').tail
---@param winid number
---@return string filename
function M.tail(winid)
  return filename.tail(winid)
end

---@deprecated use require('tabby.module.filename').shorten
---@param winid number
---@return string filename
function M.shorten(winid)
  return filename.shorten(winid)
end

---@deprecated use require('tabby.module.filename').unique
---@param winid number
---@return string filename
function M.unique(winid)
  return filename.unique(winid)
end

return M
