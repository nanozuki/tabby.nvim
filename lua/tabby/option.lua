local presets = require('tabby.presets')

local option = {}

---@class TabbyOption
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api
---@field show_mode? "disable"|"always"|"auto"

---@type TabbyOption
option.defaults = {
  tabline = presets.active_wins_at_tail,
  showtabline = 'always',
}

return option
