local render = {}

local defaults = require("styletabs.defaults")

local text_default = {
	align = "left",
	maxwid = 0,
	minwid = 0,
	hl = "",
}

local hl_default = {
	fg = "",
	bg = "",
	style = "",
	name = "",
}

function render.text(t)
	local obj = {}
	if type(t) == "string" then
		obj[1] = t
	elseif type(t) == "table" then
		obj = t
	end
	local head = {}
	local tail = {}
	if (obj.maxwid or 0) > 0 or (obj.minwid or 0) > 0 then
		local align = "-"
		if align == "right" then
			align = ""
		end
		render = string.format("%%%s%d.%d(", align, obj.minwid, obj.maxwid)
		table.insert(head, render)
		table.insert(tail, "%)")
	end
	table.insert(head, string.format("%%#%s#", render.parse_hl(obj.hl)))
	return string.format("%s%s%s", table.concat(head), obj[1], table.concat(tail))
end

function render.parse_text(t)
	if type(t) == "string" then
		return { t }
	elseif type(t) ~= "table" then
		error("invalid text: must be string or table")
	end
	if (t[1] or "") == "" then
		error("invalid text, no text content")
	end
	return vim.tbl_deep_extend("force", text_default, t)
end

function render.parse_hl(hl)
	if type(hl) == "string" then
		return hl
	end
	hl = vim.tbl_extend("force", hl_default, hl)
	if hl.fg == "" and hl.bg == "" and hl.style == "" then
		return ""
	end
	if hl.name == "" then
		hl.name = string.gsub(string.format("StyledTabsHl_%s_%s_%s", hl.fg, hl.bg, hl.style), "#", "")
	end
	local cmd = { "hi", hl.name }
	if hl.fg ~= "" then
		table.insert(cmd, "guifg=" .. hl.fg)
	end
	if hl.bg ~= "" then
		table.insert(cmd, "guibg=" .. hl.bg)
	end
	if hl.style ~= "" then
		table.insert(cmd, "gui=" .. hl.style)
	end
	local hl_str = table.concat(cmd, " ")
	vim.cmd(hl_str)
	return hl.name
end

function render.active_tab(tabid, opt)
	opt = vim.tbl_extend("force", defaults.active_tab, opt)
	local label = opt.label
	if type(label) == "function" then
		label = label(tabid)
	end
	local hl = render.parse_hl(opt.hl)
	label = render.text({
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
	local left_sep = render.text({ opt.left_sep, hl = opt.left_sep_hl })
	local right_sep = render.text({ opt.right_sep, hl = opt.right_sep_hl })
	return table.concat({ "%", tabid, "T", left_sep, label, right_sep, "%T" })
	-- close tab: %<tabid>X<icon>%X
end

function render.inactive_tab(tabid, opt)
	opt = vim.tbl_extend("force", defaults.inactive_tab, opt)
	local label = opt.label
	if type(label) == "function" then
		label = label(tabid)
	end
	local hl = render.parse_hl(opt.hl)
	label = render.text({
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
	local left_sep = render.text({ opt.left_sep, hl = opt.left_sep_hl })
	local right_sep = render.text({ opt.right_sep, hl = opt.right_sep_hl })
	return table.concat({ "%", tabid, "T", left_sep, label, right_sep, "%T" })
end

function render.active_tab_win(winid, opt)
	opt = vim.tbl_extend("force", defaults.active_tab_win, opt)
	local label = opt.label
	if type(label) == "function" then
		label = label(winid)
	end
	local hl = render.parse_hl(opt.hl)
	label = render.text({
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
	local left_sep = render.text({ opt.left_sep, hl = opt.left_sep_hl })
	local right_sep = render.text({ opt.right_sep, hl = opt.right_sep_hl })
	local bufid = vim.api.nvim_win_get_buf(winid)
	return table.concat({ "%", bufid, "@StyletabsBufClickHandler@", left_sep, label, right_sep, "%T" })
end

return render
