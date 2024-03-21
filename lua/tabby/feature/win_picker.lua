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

return win_picker
