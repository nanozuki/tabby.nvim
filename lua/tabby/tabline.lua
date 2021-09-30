local component = require("tabby.component")

--- render TabbyTablineOpt
local tabline = {}

---@class TabbyTablineOpt
---@field hl TabbyHighlight background highlight
---@field head? TabbyText[]
---@field active_tab TabbyTabLabelOpt
---@field inactive_tab TabbyTabLabelOpt
---@field window_mode TabbyWinLabelMode
---@field active_win TabbyWinLabelOpt
---@field active_front_win? TabbyWinLabelOpt need by "active-only", fallback to active_win if this is nil
---@field inactive_win? TabbyWinLabelOpt
---@field tail? TabbyText[]

---@class TabbyTabLabelOpt
---@field label string|TabbyText|fun(tabid:number):TabbyText
---@field left_sep string|TabbyText
---@field right_sep string|TabbyText

---@alias TabbyWinLabelMode
---| "after-active-tab" # windows label follow active tab
---| "active-wins-at-end" # windows in active tab will be display at end of all tab labels
---| "front-only"  # only display the front window. (the window will focus when you enter a tabpage.)

---@class TabbyWinLabelOpt
---@field mode TabbyWinLabelMode
---@field label string|TabbyText|fun(winid:number):TabbyText
---@field left_sep string|TabbyText
---@field inner_sep string|TabbyText won't works in "front-only" mode
---@field right_sep string|TabbyText

---@param tabid number tab id
---@param opt TabbyTabLabelOpt
---@return TabbyComTab
function tabline.render_tab_label(tabid, opt)
	local label = opt.label
	if type(opt.label) == "function" then
		label = opt.label(tabid)
	end
	return {
		type = "tab",
		tabid = tabid,
		label = label,
		left_sep = opt.left_sep,
		right_sep = opt.right_sep,
	}
end

---@param winid number window id
---@param is_first boolean
---@param is_last boolean
---@param opt TabbyWinLabelOpt
---@return TabbyComWin
function tabline.render_win_label(winid, is_first, is_last, opt)
	local label = opt.label
	if type(opt.label) == "function" then
		label = opt.label(winid)
	end
	local left_sep = opt.inner_sep
	local right_sep = opt.inner_sep
	if is_first then
		left_sep = opt.left_sep
	end
	if is_last then
		right_sep = opt.right_sep
	end
	return {
		type = "win",
		winid = winid,
		label = label,
		left_sep = left_sep,
		right_sep = right_sep,
	}
end

---@param opt TabbyTablineOpt
---@return string statusline-format text
function tabline.render(opt)
	---@type TabbyComponent[]
	local coms = {}
	-- head
	if opt.head then
		for _, head_item in ipairs(opt.head) do
			table.insert(coms, { type = "text", text = head_item })
		end
	end
	-- tabs and wins
	local tabs = vim.api.nvim_list_tabpages()
	local current_tab = vim.api.nvim_get_current_tabpage()
	for _, tabid in ipairs(tabs) do
		if tabid == current_tab then
			table.insert(coms, tabline.render_tab_label(tabid, opt.active_tab))
			if opt.window_mode == "after-active-tab" then
				local wins = vim.api.nvim_tabpage_list_wins(current_tab)
				local top_win = vim.api.nvim_tabpage_get_win(current_tab)
				for i, winid in ipairs(wins) do
					local win_opt = opt.active_win
					if winid == top_win and opt.active_front_win ~= nil then
						win_opt = opt.active_front_win
						table.insert(coms, tabline.render_win_label(winid, i == 1, i == #wins, win_opt))
					end
				end
			end
		else
			table.insert(coms, tabline.render_tab_label(tabid, opt.inactive_tab))
		end
		if opt.window_mode == "front-only" then
			local win_opt = opt.inactive_win
			if tabid == current_tab then
				win_opt = opt.active_win
			end
			local winid = vim.api.nvim_tabpage_get_win(tabid)
			table.insert(coms, tabline.render_win_label(winid, true, true, win_opt))
		end
	end
	if opt.window_mode == "active-wins-at-end" then
		local wins = vim.api.nvim_tabpage_list_wins(current_tab)
		local top_win = vim.api.nvim_tabpage_get_win(current_tab)
		for i, winid in ipairs(wins) do
			local win_opt = opt.active_win
			if winid == top_win and opt.active_front_win ~= nil then
				win_opt = opt.active_front_win
				table.insert(coms, tabline.render_win_label(winid, i == 1, i == #wins, win_opt))
			end
		end
	end
	-- empty space in line
	table.insert(coms, { type = "text", text = { "", hl = opt.hl } })
	-- tail
	if opt.tail then
		table.insert(coms, { type = "text", text = { "%=" } })
		for _, tail_item in ipairs(opt.tail) do
			table.insert(coms, { type = "text", text = tail_item })
		end
	end

	return table.concat(vim.tbl_map(component.render, coms))
end

return tabline
