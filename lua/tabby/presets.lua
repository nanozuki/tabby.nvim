local filename = require("tabby.filename")
local util = require("tabby.util")

local hl_tabline = util.extract_nvim_hl("TabLine")
local hl_normal = util.extract_nvim_hl("Normal")
local hl_tabline_sel = util.extract_nvim_hl("TabLineSel")
local hl_tabline_fill = util.extract_nvim_hl("TabLineFill")

---@type table<TabbyTablineLayout, TabbyTablineOpt>
local presets = {
	active_wins_at_end = {
		hl = "TabLine",
		layout = "active_wins_at_end",
		head = {
			{ "  ", hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
			{ "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		active_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
		},
		inactive_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
		},
		top_win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = "TabLine",
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = "TabLine",
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
	},
	active_tab_with_wins = {
		hl = "TabLine",
		layout = "active_tab_with_wins",
		head = {
			{ "  ", hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = "italic" } },
			{ "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		active_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
		},
		inactive_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
		},
		top_win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = "TabLine",
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = "TabLine",
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
	},
	tab_with_top_win = {
		hl = "TabLine",
		layout = "tab_with_top_win",
		head = {
			{ "  ", hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = "italic" } },
			{ "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		active_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
		},
		inactive_tab = {
			label = function(tabid)
				return {
					"  " .. tabid .. " ",
					hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
		},
		active_win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = "TabLine",
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
		win = {
			label = function(winid)
				return {
					"  " .. filename.unique(winid) .. " ",
					hl = "TabLine",
				}
			end,
			left_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
			right_sep = { "", hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
		},
	},
}

return presets
