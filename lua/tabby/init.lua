local tabby = {}

local option = require("tabby.option")
local component = require("tabby.component")
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
	return option.render_tabline(option.defaults.tabline)
end

function tabby.handle_buf_click()
	-- function tabby.handle_buf_click(minwid, clicks, button, modifier)
	-- print("buf click: ", minwid, clicks, button, modifier)
end

return tabby
