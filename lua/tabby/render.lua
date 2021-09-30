local render = {}

---@param tabid number tab id
---@param cfg table config
---@return TabbyComTab
function render.tab(tabid, cfg)
	return {
		type = "tab",
		tabid = tabid,
		label = {
			cfg.label(tabid),
			hl = cfg.hl,
			layout = {
				min_width = cfg.min_width,
				max_width = cfg.max_width,
				justify = cfg.align,
			},
		},
		left_sep = {
			cfg.left_sep,
			hl = cfg.left_sep_hl,
		},
		right_sep = {
			cfg.right_sep,
			hl = cfg.right_sep_hl,
		},
	}
end

---@param coms TabbyComponent[] component arrays
---@param wins number[] window ids
---@param cfg table config
---@return TabbyComWin
function render.active_tab_wins(coms, wins, cfg)
	if #wins == 0 then
		return
	end

	if cfg.left_sep_hl == "" then
		cfg.left_sep_hl = cfg.hl
	end
	if cfg.right_sep_hl == "" then
		cfg.right_sep_hl = cfg.hl
	end
	if cfg.inner_sep_hl == "" then
		cfg.inner_sep_hl = cfg.hl
	end
	table.insert(coms, { type = "text", text = { cfg.left_sep, hl = cfg.left_sep_hl } })
	for i, winid in ipairs(wins) do
		table.insert(coms, {
			type = "win",
			winid = winid,
			label = {
				cfg.label(winid),
				hl = cfg.hl,
			},
			left_sep = "",
			right_sep = "",
		})
		if i ~= #wins then
			table.insert(coms, { type = "text", text = { cfg.inner_sep, hl = cfg.inner_sep_hl } })
		end
	end
	table.insert(coms, { type = "text", text = { cfg.right_sep, hl = cfg.right_sep_hl } })
end

return render
