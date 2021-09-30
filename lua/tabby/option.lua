local util = require("tabby.util")
local component = require("tabby.component")

local option = {}

---@class TabbyTabLabelOpt
---@field label string|function(tabid):TabbyText
---@field left_sep string|TabbyText
---@field right_sep string|TabbyText

---@alias TabbyWinLabelMode
---| "active-only" # windows in active tab will be display
---| "front-only"  # only display the front window. (the window will focus when you enter a tabpage.)

---@class TabbyWinLabelOpt
---@field mode TabbyWinLabelMode
---@field label string|function(winid):TabbyText
---@field left_sep string|TabbyText
---@field inner_sep string|TabbyText won't works in "front-only" mode
---@field right_sep string|TabbyText

---@class TabbyTablineOpt
---@field head? TabbyText[]
---@field active_tab TabbyTabLabelOpt
---@field inactive_tab TabbyTabLabelOpt
---@field window_mode TabbyWinLabelMode
---@field active_win TabbyWinLabelOpt
---@field active_front_win? TabbyWinLabelOpt need by "active-only", fallback to active_win if this is nil
---@field inactive_win? TabbyWinLabelOpt
---@field tail? TabbyText[]

---@class TabbyOption
---@field tabline? TabbyTablineOpt                high-level api
---@field components? function():TabbyComponent[] low-level api

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
