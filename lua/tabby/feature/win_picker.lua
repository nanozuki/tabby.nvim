local win_picker = {}

local win_module = require('tabby.feature.wins')
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
  local new_win = function(winid)
    return win_module.new_win(winid, opt)
  end
  local wins = vim.iter(api.get_wins()):map(new_win):totable() ---@type TabbyWin[]
  vim.ui.select(wins, {
    format_item = function(win)
      return string.format('Tab %s: %s', win.tab().name(), win.buf_name())
    end,
  }, function(win)
    if win ~= nil then
      vim.api.nvim_set_current_win(win.id)
    end
  end)
end

return win_picker
