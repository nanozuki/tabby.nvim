local mappings = {}

--- Focus tab based on the visual position of the tab in the tabline.
--- The order of the list is from left to right with a the start as 1.
--- If number is beyond the bounds of the tabpages it will do nothing.
---@param n number visual tab number to focus
function mappings.focus_visual_tab(n)
	local list = vim.api.nvim_list_tabpages()
	if n > #list then
		return
	end

	vim.api.nvim_set_current_tabpage(list[n])
end

return mappings
