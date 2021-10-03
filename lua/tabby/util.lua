local util = {}

---@param name string
---@return TabbyHighlight
function util.extract_nvim_hl(name)
	local hl_str = vim.api.nvim_exec("highlight " .. name, true)
	return {
		fg = hl_str:match("guifg=(#[0-9A-Fa-f]+)") or "#444444",
		bg = hl_str:match("guibg=(#[0-9A-Fa-f]+)") or "#1E1E1E",
		style = hl_str:match("gui=(#[0-9A-Fa-f]+)") or "",
		name = name,
	}
end

return util
