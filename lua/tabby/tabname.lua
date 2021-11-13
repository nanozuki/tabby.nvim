local util = require('tabby.util')
local filename = require('tabby.filename')

local tabname = {
  names = {},
}

function tabname.set(tabid, name)
  tabname.names[tabid] = name
end

function tabname.get(tabid)
  local number = vim.api.nvim_tabpage_get_number(tabid)
  print(string.format('get tab %d name = %s', tabid, tabname.names[tabid]))
  if tabname.names[tabid] and tabname.names[tabid] ~= '' then
    return number .. ': ' .. tabname.names[tabid]
  end
  local wins = util.tabpage_list_wins(tabid)
  local focus_win = vim.api.nvim_tabpage_get_win(tabid)
  local name = ''
  if vim.api.nvim_win_get_config(focus_win).relative ~= '' then
    name = '[floating]'
  else
    name = filename.unique(focus_win)
  end
  if #wins > 1 then
    name = string.format('%s[%d+]', name, #wins - 1)
  end
  return number .. ': ' .. name
end

return tabname
