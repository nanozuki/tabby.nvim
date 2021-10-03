local tabby = {}

local option = require("tabby.option")
local tabline = require("tabby.tabline")
local component = require("tabby.component")

---@type nil|TabbyOption
local tabby_opt = nil

---@param opt? TabbyOption
function tabby.setup(opt)
	tabby_opt = opt or option.defaults
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
	if tabby_opt.components ~= nil then
		local components = tabby_opt.components()
		return table.concat(vim.tbl_map(component.render, components), "")
	elseif tabby_opt.tabline ~= nil then
		return tabline.render(tabby_opt.tabline)
	else
		return tabline.render(option.defaults)
	end
end

function tabby.handle_buf_click()
	-- do nothing at now, only recording the sign for function
	-- function tabby.handle_buf_click(minwid, clicks, button, modifier)
	-- print("buf click: ", minwid, clicks, button, modifier)
end

return tabby
