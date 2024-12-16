local filename = {}
local win_name = require('tabby.feature.win_name')

---@deprecated use require('tabby.feature.win_name').get(winid, { mode = 'relative' })
---@param winid number
---@return string filename
function filename.relative(winid)
  return win_name.get(winid, { mode = 'relative' })
end

---@deprecated use require('tabby.feature.win_name').get(winid, { mode = 'tail' })
---@param winid number
---@return string filename
function filename.tail(winid)
  return win_name.get(winid, { mode = 'tail' })
end

---@deprecated use require('tabby.feature.win_name').get(winid, { mode = 'shorten' })
---@param winid number
---@return string filename
function filename.shorten(winid)
  return win_name.get(winid, { mode = 'shorten' })
end

---@deprecated use require('tabby.feature.win_name').get(winid, { mode = 'unique' })
---@param winid number
---@return string filename
function filename.unique(winid)
  return win_name.get(winid, { mode = 'unique' })
end

return filename
