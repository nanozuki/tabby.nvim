local render = {}

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
		hl.name = string.gsub(string.format("TabbyHl_%s_%s_%s", hl.fg, hl.bg, hl.style), "#", "")
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

---@param tabid number tab id
---@param cfg table config
---@return TabbyComTab
function render.tab(tabid, cfg)
	return {
		type = "tab",
		tabid = tabid,
		label = {
			cfg.label(tabid),
			hl = cfg.hl,
			layout = {
				min_width = cfg.min_width,
				max_width = cfg.max_width,
				justify = cfg.align,
			},
		},
		left_sep = {
			cfg.left_sep,
			hl = cfg.left_sep_hl,
		},
		right_sep = {
			cfg.right_sep,
			hl = cfg.right_sep_hl,
		},
	}
end

---@param winid number window id
---@param cfg table config
---@return TabbyComWin
function render.active_tab_win(winid, cfg)
	if cfg.left_sep_hl == "" then
		cfg.left_sep_hl = cfg.hl
	end
	if cfg.right_sep_hl == "" then
		cfg.right_sep_hl = cfg.hl
	end
	return {
		type = "win",
		winid = winid,
		label = {
			cfg.label(winid),
			hl = cfg.hl,
		},
		left_sep = {
			cfg.left_sep,
			hl = cfg.left_sep_hl,
		},
		right_sep = {
			cfg.right_sep,
			hl = cfg.right_sep_hl,
		},
	}
end

return render
