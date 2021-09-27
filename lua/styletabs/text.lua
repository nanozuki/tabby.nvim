local text = {}

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

function text.render(t)
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
		text = string.format("%%%s%d.%d(", align, obj.minwid, obj.maxwid)
		table.insert(head, text)
		table.insert(tail, "%)")
	end
	table.insert(head, string.format("%%#%s#", text.parse_hl(obj.hl)))
	return string.format("%s%s%s", table.concat(head), obj[1], table.concat(tail))
end

function text.parse_text(t)
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

function text.parse_hl(hl)
	if type(hl) == "string" then
		return hl
	end
	hl = vim.tbl_extend("force", hl_default, hl)
	if hl.fg == "" and hl.bg == "" and hl.style == "" then
		return ""
	end
	if hl.name == "" then
		hl.name = string.format("StyledTabsHl_%s_%s", hl.fg, hl.bg)
	end
	vim.nvim_set_hl(0, hl.name, { guifg = hl.fg, guibg = hl.bg, gui = hl.style })
	return hl.name
end

return text
