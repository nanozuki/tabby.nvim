local api = require('tabby.api')
local opts = require('tabby.provider.opts')
local win = require('tabby.provider.win')

local tab = {}

---wrap window provider to tab provider
---@param provider fun(winid:number):string
---@return fun(tabid:number):string
local function wrap_win_provider(provider)
  ---@type fun(tabid:number):string
  return function(tabid)
    local winid = api.tab.get_focus_win(tabid)
    return provider(winid)
  end
end

tab.focus_win = {
  filename = wrap_win_provider(win.filename),
  fileicon = wrap_win_provider(win.fileicon),
  modified = wrap_win_provider(win.modified),
  read_only = wrap_win_provider(win.read_only),
}

---return tab's number
---@param tabid number
---@return string
function tab.number(tabid)
  return tostring(api.tab.get_number(tabid))
end

---@class TabbyTabNameOpt
---@param fallback fun(tabid:number):string fallback function when a tab with no name.

function tab.name(tabid)
  local opt = opts.tab.name
  local name = api.tab.get_name(tabid)
  if name and name ~= '' then
    return name
  end
  return opt.fallback(tabid)
end

function tab.win_count(tabid)
  local wins = api.tab.list_wins(tabid)
  return #wins
end

---@class TabbyTabCloseBtnOpt
---@field icon string

---display a button for close btn
---@param tabid number
---@return string
function tab.close_btn(tabid)
  local n = api.tab.get_number(tabid)
  return string.format('%%%dXclose%%X', n)
end

return tab
