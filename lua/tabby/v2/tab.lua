local tab = {}
local option = require('v2.option')

function tab.number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

function tab.name(tabid)
  local name = vim.api.nvim_tabpage_get_var(tabid, 'name')
  return name or option.tab.default_tab_name(tabid)
end

---list all fixed wins
---@return number[] array of window ids
function tab.list_wins()
  local winids = vim.api.nvim_list_wins()
  return vim.tbl_filter(function(winid)
    return vim.api.nvim_win_get_config(winid).relative == ''
  end, winids)
end

function tab.win_count(tabid)
  local wins = tab.tabpage_list_wins(tabid)
  return #wins
end

function tab.close_btn(icon)
  return function(tabid)
    return icon .. tabid
  end
end

return tab
