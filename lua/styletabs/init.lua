local styletabs = {}

function styletabs.setup()
	if vim.api.nvim_get_vvar("vim_did_enter") then
		styletabs.init()
	else
		vim.cmd("au VimEnter * lua require'styletabs'.init()")
	end
end

function styletabs.init()
	vim.o.showtabline = 2
	vim.o.tabline = "%!v:lua.styletabs()"
end

function styletabs.update()
	local tabs = vim.api.nvim_list_tabpages()
	local config = require("styletabs.config").get()
	local tablines = {}
	for _, tabid in ipairs(tabs) do
		if tabid == vim.api.nvim_get_current_tabpage() then
			local wins = vim.api.nvim_tabpage_list_wins(tabid)
			local tab_texts = {}
			for _, winid in ipairs(wins) do
				local bufid = vim.api.nvim_win_get_buf(winid)
				local buf_name = vim.api.nvim_buf_get_name(bufid)
				table.insert(tab_texts, vim.fn.fnamemodify(buf_name, ":~:."))
			end
			table.insert(tablines, "【tab:" .. tabid .. "】" .. table.concat(tab_texts, ","))
		else
			table.insert(tablines, "[tab:" .. tabid .. "]")
		end
	end
	return table.concat(tablines, " ")
end

function _G.styletabs()
	return require("styletabs").update()
end

return styletabs
