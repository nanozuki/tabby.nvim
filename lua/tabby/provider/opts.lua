---@class TabbyProviderOpts
---@field tab TabbyTabProviderOpts
---@field win TabbyWinProviderOpts

---@class TabbyWinProviderOpts
---@field filename TabbyFilenameOpt
---@field modified TabbyWinModifiedOpt
---@field read_only TabbyWinReadOnlyOpt

---@class TabbyTabProviderOpts
---@field name TabbyTabNameOpt
---@field close_btn TabbyTabCloseBtnOpt

---@type TabbyProviderOpts
local provider_opt = {
  win = {
    filename = {
      mode = 'unique',
      placeholder = '[No Name]',
    },
    modified = {
      icon = '',
    },
    read_only = {
      icon = '',
    },
  },
  tab = {
    name = {
      fallback = function(tabid)
        local api = require('tabby.api')
        local focus_win = api.tab.get_focus_win(tabid)
        local wins = api.tab.list_wins(tabid)
        local name = ''
        if api.win.is_relative(focus_win) then
          name = '[Floating]'
        else
          name = require('tabby.win').filename(focus_win)
        end
        if #wins > 1 then
          name = string.format('%s[%d+]', name, #wins - 1)
        end
        return name
      end,
    },
    close_btn = {
      icon = '',
    },
  },
}

return provider_opt
