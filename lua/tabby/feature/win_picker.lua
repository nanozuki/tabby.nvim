local win_picker = {}

local tabwins = require('tabby.feature.tabwins')
local api = require('tabby.module.api')

---@type TabbyLineOption
local opt = {
  tab_name = {
    name_fallback = function(tabid)
      local number = api.get_tab_number(tabid)
      return tostring(number)
    end,
  },
}

function win_picker.select()
  local wins = tabwins.new_wins(api.get_wins(), opt).wins
  vim.ui.select(wins, {
    format_item = function(win)
      return string.format('Tab %s: %s', win.tab().name(), win.buf_name())
    end,
  }, function(win)
    vim.api.nvim_set_current_win(win.id)
  end)
end

win_picker.tabline_alt_draw = false

function win_picker.toggle_alt_draw()
  win_picker.tabline_alt_draw = not win_picker.tabline_alt_draw
  vim.cmd.redrawtabline()
  if win_picker.tabline_alt_draw then
    local line_opt = require('tabby.tabline').cfg.opt -- TODO: ugly, refact this
    local tabs = tabwins.new_tabs(line_opt or {}).tabs
  end
end

return win_picker
