local config = {}

local defaults = {
	hl = "Whitespace",
	active_tab = {
		label = function(tabid)
			return "tab:" .. tabid
		end,
		hl = "TabLineSel",
		left_sep = "【",
		right_sep = "】 ",
	},
	inactive_tab = {
		label = function(tabid)
			return "tab:" .. tabid
		end,
		hl = "TabLine",
		left_sep = "[",
		right_sep = "] ",
	},
	active_tab_win = {
		label = function(winid)
			local bufid = vim.api.nvim_win_get_buf(winid)
			local buf_name = vim.api.nvim_buf_get_name(bufid)
			return vim.fn.fnamemodify(buf_name, ":~:.")
		end,
		hl = "TabLineFill",
		right_sep = " ",
	},
}

function config.get()
	return defaults
end

return config
