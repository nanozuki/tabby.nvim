local util = require("tabby.util")

local option = {}

---@class TabbyOption
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api

local hl_tabline = util.extract_nvim_hl("TabLine")
local hl_tabline_sel = util.extract_nvim_hl("TabLineSel")
local hl_tabline_fill = util.extract_nvim_hl("TabLineFill")

---@type TabbyOption
option.defaults = {
	tabline = {
		head = {
			{ " Tabs ", hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg } },
			{ "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
		},
		active_tab = {
			label = function(tabid)
				return {
					" " .. tabid .. " ",
					hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
		},
		inactive_tab = {
			label = function(tabid)
				return {
					" " .. tabid .. " ",
					hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		window_mode = "active-only",
		active_front_win = {
			label = function(winid)
				local bufid = vim.api.nvim_win_get_buf(winid)
				local buf_name = vim.api.nvim_buf_get_name(bufid)
				return {
					"  " .. vim.fn.fnamemodify(buf_name, ":~:."),
					hl = "TabLineFill",
				}
			end,
			left_sep = { "  ", hl = "TabLineFill" },
			inner_sep = { "  ", hl = "TabLineFill" },
			right_sep = { "  ", hl = "TabLineFill" },
		},
		active_win = {
			label = function(winid)
				local bufid = vim.api.nvim_win_get_buf(winid)
				local buf_name = vim.api.nvim_buf_get_name(bufid)
				return {
					"  " .. vim.fn.fnamemodify(buf_name, ":~:."),
					hl = "TabLineFill",
				}
			end,
			left_sep = { "  ", hl = "TabLineFill" },
			inner_sep = { "  ", hl = "TabLineFill" },
			right_sep = { "  ", hl = "TabLineFill" },
		},
	},
}

---parse TabbyOption.tabline and render to tabline
---@param tabline_opt TabbyTablineOpt
---@return string statusline-format text
function option.render_tabline(tabline_opt) end

return option
