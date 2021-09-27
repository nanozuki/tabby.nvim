local render = {}

local active_tab_defaults = {
	label = function(tabid)
		return "Tab:" .. tabid
	end,
	hl = "TabLineSel",
	max_width = 0,
	min_width = 0,
	aligh = "left",

	left_sep = "┃",
	right_sep = "┃",
	left_sep_hl = "",
	right_sep_hl = "",
}

function render.active_tab(tabid, opt)
	opt = vim.tbl_extend("force", active_tab_defaults, opt)
	local label = opt.label
	if type(label) == "function" then
		label = label(tabid)
	end
	local hl = require("styletabs.text").parse_hl(opt.hl)
	label = require("styletabs.text").render({
		label,
		hl = hl,
		maxwid = opt.max_width,
		minwid = opt.min_width,
		aligh = opt.aligh,
	})
	if opt.left_sep_hl == "" then
		opt.left_sep_hl = hl
	end
	if opt.right_sep_hl == "" then
		opt.right_sep_hl = hl
	end
	local left_sep = require("styletabs.text").render({ opt.left_sep, hl = opt.left_sep_hl })
	local right_sep = require("styletabs.text").render({ opt.right_sep, hl = opt.right_sep_hl })
	return table.concat({ "%", tabid, "T", left_sep, label, right_sep, "%T" })
	-- close tab: %<tabid>X<icon>%X
end

local inactive_tab_defaults = {
	label = function(tabid)
		return "Tab:" .. tabid
	end,
	hl = "TabLineSel",
	max_width = 0,
	min_width = 0,
	aligh = "left",

	left_sep = "│",
	right_sep = "│",
	left_sep_hl = "",
	right_sep_hl = "",
}

function render.inactive_tab(tabid, opt)
	opt = vim.tbl_extend("force", inactive_tab_defaults, opt)
	local label = opt.label
	if type(label) == "function" then
		label = label(tabid)
	end
	local hl = require("styletabs.text").parse_hl(opt.hl)
	label = require("styletabs.text").render({
		label,
		hl = hl,
		maxwid = opt.max_width,
		minwid = opt.min_width,
		aligh = opt.aligh,
	})
	if opt.left_sep_hl == "" then
		opt.left_sep_hl = hl
	end
	if opt.right_sep_hl == "" then
		opt.right_sep_hl = hl
	end
	local left_sep = require("styletabs.text").render({ opt.left_sep, hl = opt.left_sep_hl })
	local right_sep = require("styletabs.text").render({ opt.right_sep, hl = opt.right_sep_hl })
	return table.concat({ "%", tabid, "T", left_sep, label, right_sep, "%T" })
end

local active_tab_win_defaults = {
	label = function(winid)
		local bufid = vim.api.nvim_win_get_buf(winid)
		local buf_name = vim.api.nvim_buf_get_name(bufid)
		return vim.fn.fnamemodify(buf_name, ":~:.")
	end,
	hl = "TabLineFill",
	left_sep = "│",
	right_sep = "│",
	left_sep_hl = "",
	right_sep_hl = "",
}

function render.active_tab_win(winid, opt)
	opt = vim.tbl_extend("force", active_tab_win_defaults, opt)
	opt = vim.tbl_extend("force", inactive_tab_defaults, opt)
	local label = opt.label
	if type(label) == "function" then
		label = label(winid)
	end
	local hl = require("styletabs.text").parse_hl(opt.hl)
	label = require("styletabs.text").render({
		label,
		hl = hl,
		maxwid = opt.max_width,
		minwid = opt.min_width,
		aligh = opt.aligh,
	})
	if opt.left_sep_hl == "" then
		opt.left_sep_hl = hl
	end
	if opt.right_sep_hl == "" then
		opt.right_sep_hl = hl
	end
	local left_sep = require("styletabs.text").render({ opt.left_sep, hl = opt.left_sep_hl })
	local right_sep = require("styletabs.text").render({ opt.right_sep, hl = opt.right_sep_hl })
	local bufid = vim.api.nvim_win_get_buf(winid)
	return table.concat({ "%", bufid, "@StyletabsBufClickHandler@", left_sep, label, right_sep, "%T" })
end

return render
