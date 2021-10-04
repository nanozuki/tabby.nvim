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

function util.list_wins()
	local winids = vim.api.nvim_list_wins()
	return vim.tbl_filter(function(winid)
		return vim.api.nvim_win_get_config(winid).relative == ""
	end, winids)
end

function util.tabpage_list_wins(tabid)
	local winids = vim.api.nvim_tabpage_list_wins(tabid)
	return vim.tbl_filter(function(winid)
		return vim.api.nvim_win_get_config(winid).relative == ""
	end, winids)
end

return util
