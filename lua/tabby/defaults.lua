local function extract_nvim_hl(name)
	local hl_str = vim.api.nvim_exec("highlight " .. name, true)
	return {
		fg = hl_str:match("guifg=(#[0-9A-Fa-f]+)") or "#444444",
		bg = hl_str:match("guibg=(#[0-9A-Fa-f]+)") or "#1E1E1E",
		style = hl_str:match("gui=(#[0-9A-Fa-f]+)") or "",
	}
end

local hl_tabline = extract_nvim_hl("TabLine")
local hl_tabline_sel = extract_nvim_hl("TabLineSel")
local hl_tabline_fill = extract_nvim_hl("TabLineFill")

local defaults = {
	hl = "TabLineFill",
	head = {
		{ " Tabs ", hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg } },
		{ "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
	},
	active_tab = {
		label = function(tabid)
			return " " .. tabid .. " "
		end,
		hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
		max_width = 0,
		min_width = 0,
		aligh = "left",

		left_sep = "",
		left_sep_hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg },
		right_sep = "",
		right_sep_hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg },
	},
	inactive_tab = {
		label = function(tabid)
			return " " .. tabid .. " "
		end,
		hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = "bold" },
		max_width = 0,
		min_width = 0,
		aligh = "left",

		left_sep = "",
		left_sep_hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg },
		right_sep = "",
		right_sep_hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg },
	},
	active_tab_win = {
		label = function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)
			local buf_name = vim.api.nvim_buf_get_name(bufid)
			return "  " .. vim.fn.fnamemodify(buf_name, ":~:.")
		end,
		hl = "TabLineFill",
		left_sep = "%=",
		right_sep = "",
		inner_sep = "",
		left_sep_hl = "",
		inner_sep_hl = "",
		right_sep_hl = "",
	},
}

return defaults
