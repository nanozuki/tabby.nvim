local tab = {}
local option = require('v2.option')

function tab.number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

function tab.name(tabid)
  local name = vim.api.nvim_tabpage_get_var(tabid, 'name')
  return name or option.tab.default_tab_name(tabid)
end

return tab
