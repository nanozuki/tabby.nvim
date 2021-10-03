local util = require("tabby.util")
local presets = require("tabby.presets")

local option = {}

---@class TabbyOption
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api

---@type TabbyOption
option.defaults = {
	tabline = presets.active_wins_at_end,
}

---parse TabbyOption.tabline and render to tabline
---@param tabline_opt TabbyTablineOpt
---@return string statusline-format text
function option.render_tabline(tabline_opt)
	return require("tabby.tabline").render(tabline_opt)
end

return option
