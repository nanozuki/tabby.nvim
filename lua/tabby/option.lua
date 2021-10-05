local presets = require("tabby.presets")

local option = {}

---@class TabbyOption
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api

---@type TabbyOption
option.defaults = {
	tabline = presets.active_wins_at_tail,
}

return option
