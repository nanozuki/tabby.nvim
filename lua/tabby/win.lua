---@deprecated
local win = {}

local api = require('tabby.module.api')

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
