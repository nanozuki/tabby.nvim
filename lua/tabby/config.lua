local presets = require('tabby.presets')

local config = {}

---@class TabbyConfig
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api
---@field opt? TabbyOption

---@class TabbyOption
---@field show_at_least number show tabline when there are at least n tabs.

---@type TabbyConfig
config.defaults = {
  tabline = presets.active_wins_at_tail,
  showtabline = 'always',
  opt = {
    show_at_least = 1,
  },
}

return config
