local presets = require('tabby.presets')

local config = {}

---@class TabbyLegacyConfig
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api
---@field opt? TabbyLegacyOption

---@class TabbyLegacyOption
---@field show_at_least number show tabline when there are at least n tabs.

---@type TabbyLegacyConfig
config.defaults = {
  tabline = presets.active_wins_at_tail,
  opt = { show_at_least = 1 },
}

return config
