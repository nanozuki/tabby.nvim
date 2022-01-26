local win = require('tabby.win')

local tab = {}

---return tab's number
---@param tabid number
---@return number
function tab.number(tabid)
  return vim.api.nvim_tabpage_get_number(tabid)
end

---list all fixed wins of tab
---@return number[] array of window ids
local function tabpage_list_wins(tabid)
  local winids = vim.api.nvim_tabpage_list_wins(tabid)
  return vim.tbl_filter(function(winid)
    return vim.api.nvim_win_get_config(winid).relative == ''
  end, winids)
end

local function tabname_default_fallback(tabid)
  local focus_win = vim.api.nvim_tabpage_get_win(tabid)
  local wins = tabpage_list_wins(tabid)
  local name = ''
  if vim.api.nvim_win_get_config(focus_win).relative ~= '' then
    name = '[Floating]'
  else
    name = require('tabby.win').filename(focus_win)
  end
  if #wins > 1 then
    name = string.format('%s[%d+]', name, #wins - 1)
  end
  return name
end

local function tab_name(tabid, fallback)
  local name = vim.api.nvim_tabpage_get_var(tabid, 'tabname')
  if name and name ~= '' then
    return name
  end
  fallback = fallback or tabname_default_fallback
  return fallback(tabid)
end

tab.name = setmetatable({
  ---return tab name provider with customer fallback name
  ---@param fallback fun(tabid:number):string
  ---@return fun(tabid:number):string
  fallback = function(fallback)
    return function(tabid)
      return tab_name(tabid, fallback)
    end
  end,
}, {
  ---@param tabid number
  ---@return string
  __call = function(tabid)
    return tab_name(tabid)
  end,
})

tab.filename = setmetatable({
  ---return relative filename of window
  ---@param tabid number
  ---@return string
  relative = function(tabid)
    return win.filename.relative(vim.api.nvim_tabpage_get_win(tabid))
  end,
  ---return shorten filename of window
  ---@param tabid number
  ---@return string
  shorten = function(tabid)
    return win.filename.shorten(vim.api.nvim_tabpage_get_win(tabid))
  end,
  ---return base filename of window
  ---@param tabid number
  ---@return string
  tail = function(tabid)
    return win.filename.tail(vim.api.nvim_tabpage_get_win(tabid))
  end,
  ---return unique filename of window
  ---@param tabid number
  ---@return string
  unique = tab.filename,
}, {
  ---return unique filename of window
  ---@param tabid number
  ---@return string
  __call = function(tabid)
    return win.filename.unique(vim.api.nvim_tabpage_get_win(tabid))
  end,
})

function tab.fileicon(tabid)
  return win.fileicon(vim.api.nvim_tabpage_get_win(tabid))
end

function tab.modified(icon)
  return function(tabid)
    local bufid = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabid))
    local modified = vim.api.nvim_buf_get_option(bufid, 'modified')
    if modified then
      return icon
    end
    return ''
  end
end

function tab.read_only(icon)
  return function(tabid)
    local bufid = vim.api.nvim_win_get_buf(vim.api.nvim_tabpage_get_win(tabid))
    local modifiable = vim.api.nvim_buf_get_option(bufid, 'modifiable')
    if modifiable then
      return icon
    end
    return ''
  end
end

return tab
