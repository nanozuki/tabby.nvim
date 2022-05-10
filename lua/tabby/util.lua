local util = {}

---@param name string
---@return TabbyHighlight
function util.extract_nvim_hl(name)
  local hl_str = vim.api.nvim_exec('highlight ' .. name, true)
  return {
    fg = hl_str:match('guifg=(#[0-9A-Fa-f]+)') or '',
    bg = hl_str:match('guibg=(#[0-9A-Fa-f]+)') or '',
    style = hl_str:match('gui=(#[0-9A-Fa-f]+)') or '',
    name = name,
  }
end

---list all fixed wins
---@return number[] array of window ids
function util.list_wins()
  local winids = vim.api.nvim_list_wins()
  return vim.tbl_filter(function(winid)
    return vim.api.nvim_win_get_config(winid).relative == ''
  end, winids)
end

---list all fixed wins of tab
---@return number[] array of window ids
function util.tabpage_list_wins(tabid)
  local winids = vim.api.nvim_tabpage_list_wins(tabid)
  return vim.tbl_filter(function(winid)
    return vim.api.nvim_win_get_config(winid).relative == ''
  end, winids)
end

local tab_names = {}

---@param tabid number
---@param name string
function util.set_tab_name(tabid, name)
  tab_names[tabid] = name
end

local function tab_name_default_fallback(tabid)
  local filename = require('tabby.filename')
  local wins = util.tabpage_list_wins(tabid)
  local focus_win = vim.api.nvim_tabpage_get_win(tabid)
  local name = ''
  if vim.api.nvim_win_get_config(focus_win).relative ~= '' then
    name = '[Floating]'
  else
    name = filename.unique(focus_win)
  end
  if #wins > 1 then
    name = string.format('%s[%d+]', name, #wins - 1)
  end
  return name
end

---get tab's name, if not set, will return the name made by fallback.
---@param tabid number
---@param fallback? fun(tabid:number):string Default fallback is like "init.lua[2+]", the filename is came from the focus window.
function util.get_tab_name(tabid, fallback)
  if tab_names[tabid] and tab_names[tabid] ~= '' then
    return tab_names[tabid]
  end
  fallback = fallback or tab_name_default_fallback
  return fallback(tabid)
end

--- conbine texts
---@param texts string[] texts to be combine
---@param sep? string the seprator, default is ' '
---@param left? string the left padding, default is sep
---@param right? string the left padding, default is left
---@return string combined text
function util.combine_text(texts, sep, left, right)
  sep = sep or ' '
  left = left or sep
  right = right or left
  return string.format('%s%s%s', left, table.concat(texts, sep), right)
end

return util
