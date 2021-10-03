local util = require("tabby.util")

local hl_tabline = util.extract_nvim_hl("TabLine")
local hl_normal = util.extract_nvim_hl("Normal")
local hl_tabline_sel = util.extract_nvim_hl("TabLineSel")
local hl_tabline_fill = util.extract_nvim_hl("TabLineFill")

local components = function()
	local coms = {
		{
			type = "text",
			text = {
				"  ",
				hl = { fg = hl_tabline.fg, bg = hl_tabline.bg },
			},
		},
		{
			type = "text",
			text = {
				"",
				hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg },
			},
		},
	}
	local tabs = vim.api.nvim_list_tabpages()
	local current_tab = vim.api.nvim_get_current_tabpage()
	for _, tabid in ipairs(tabs) do
		if tabid == current_tab then
			table.insert(coms, {
				type = "tab",
				tabid = tabid,
				label = {
					"  " .. tabid .. " ",
					hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = "bold" },
				},
				left_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
				right_sep = { "", hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
			})
			local wins = vim.api.nvim_tabpage_list_wins(current_tab)
			local top_win = vim.api.nvim_tabpage_get_win(current_tab)
			for _, winid in ipairs(wins) do
				local icon = "  "
				if winid == top_win then
					icon = "  "
				end
				local bufid = vim.api.nvim_win_get_buf(winid)
				local buf_name = vim.api.nvim_buf_get_name(bufid)
				table.insert(coms, {
					type = "win",
					winid = winid,
					label = icon .. vim.fn.fnamemodify(buf_name, ":~:.") .. " ",
					left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
					right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
				})
			end
		else
			table.insert(coms, {
				type = "tab",
				tabid = tabid,
				label = {
					"  " .. tabid .. " ",
					hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = "bold" },
				},
				left_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
				right_sep = { "", hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
			})
		end
	end
	-- empty space in line
	table.insert(coms, { type = "text", text = { "", hl = "TabLineFill" } })

	return coms
end

require("tabby").setup({
	components = components,
})
