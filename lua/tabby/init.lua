local tabby = {}

local defaults = require("tabby.defaults")
local render = require("tabby.render")

function tabby.setup()
	if vim.api.nvim_get_vvar("vim_did_enter") then
		tabby.init()
	else
		vim.cmd("au VimEnter * lua require'tabby'.init()")
	end
end

function tabby.init()
	vim.o.showtabline = 2
	vim.o.tabline = "%!TabbyTabline()"
end

function tabby.update()
	local tabs = vim.api.nvim_list_tabpages()
	local tablines = {}
	for _, head_item in ipairs(defaults.head) do
		table.insert(tablines, render.text(head_item))
	end
	for _, tabid in ipairs(tabs) do
		if tabid == vim.api.nvim_get_current_tabpage() then
			local tab_texts = {}
			local tab_label = render.active_tab(tabid, {})
			table.insert(tab_texts, tab_label)

			local wins = vim.api.nvim_tabpage_list_wins(tabid)
			for _, winid in ipairs(wins) do
				local text = render.active_tab_win(winid, {})
				table.insert(tab_texts, text)
			end

			table.insert(tablines, table.concat(tab_texts))
		else
			local label = render.inactive_tab(tabid, {})
			table.insert(tablines, label)
		end
	end
	table.insert(tablines, string.format("%%#%s#", render.parse_hl(defaults.hl)))
	local line = table.concat(tablines, "")
	return line
end

function tabby.handle_buf_click()
	-- function tabby.handle_buf_click(minwid, clicks, button, modifier)
	-- print("buf click: ", minwid, clicks, button, modifier)
end

return tabby
