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

---@param winid number window id
---@param cfg table config
---@return TabbyComWin
function render.active_tab_win(winid, cfg)
	if cfg.left_sep_hl == "" then
		cfg.left_sep_hl = cfg.hl
	end
	if cfg.right_sep_hl == "" then
		cfg.right_sep_hl = cfg.hl
	end
	return {
		type = "win",
		winid = winid,
		label = {
			cfg.label(winid),
			hl = cfg.hl,
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

return render
