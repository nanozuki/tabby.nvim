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
	vim.o.tabline = "%!StyletabsRender()"
end

function styletabs.update()
	local tabs = vim.api.nvim_list_tabpages()
	local tablines = {}
	for _, tabid in ipairs(tabs) do
		if tabid == vim.api.nvim_get_current_tabpage() then
			local tab_texts = {}
			local tab_label = require("styletabs.render").active_tab(tabid, {})
			table.insert(tab_texts, tab_label)

			local wins = vim.api.nvim_tabpage_list_wins(tabid)
			for _, winid in ipairs(wins) do
				local text = require("styletabs.render").active_tab_win(winid, {})
				table.insert(tab_texts, text)
			end

			table.insert(tablines, table.concat(tab_texts))
		else
			local label = require("styletabs.render").inactive_tab(tabid, {})
			table.insert(tablines, label)
		end
	end
	table.insert(tablines, "%#TabLineFill#")
	local line = table.concat(tablines, " ")
	print("tabline", line)
	return line
end

function styletabs.handle_buf_click(minwid, clicks, button, modifier)
	print("buf click: ", minwid, clicks, button, modifier)
end

return styletabs
