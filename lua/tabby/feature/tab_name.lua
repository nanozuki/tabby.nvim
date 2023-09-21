local tab_name = {}

---@class TabbyTabNameOption
---@field name_fallback fun(tabid:number):string

--TODO change the fallback to "fun(tab:TabbyTab)"

local api = require('tabby.module.api')
local buf_name = require('tabby.feature.buf_name')

---@type TabbyTabNameOption
local default_option = {
  name_fallback = function(tabid)
    local wins = api.get_tab_wins(tabid)
    local cur_win = api.get_tab_current_win(tabid)
    local name = ''
    if api.is_float_win(cur_win) then
      name = '[Floating]'
    else
      name = buf_name.get(cur_win)
    end
    if #wins > 1 then
      name = string.format('%s[%d+]', name, #wins - 1)
    end
    return name
  end,
}

---set tab option
---@param opt TabbyTabNameOption
function tab_name.set_default_option(opt)
  default_option = vim.tbl_deep_extend('force', default_option, opt)
end

--- mapping tab_name to tabid
---@type table<number, string>
local tab_names = {}

---set tab name
---@param tabid number tab id, 0 for current tab
---@param name string
function tab_name.set(tabid, name)
  if tabid == 0 then
    tabid = api.get_current_tab()
  end
  tab_names[tabid] = name
  tab_name.save()
  vim.cmd('redrawtabline')
end

---get tab's name
---@param tabid number tab id, 0 for current tab
---@param opt? TabbyTabNameOption
---@return string
function tab_name.get(tabid, opt)
  if tabid == 0 then
    tabid = api.get_current_tab()
  end
  if tab_names[tabid] ~= nil then
    return tab_names[tabid]
  end
  local o = default_option
  if opt ~= nil then
    o = vim.tbl_deep_extend('force', default_option, opt)
  end
  return o.name_fallback(tabid)
end

---get tab's raw name
---@param tabid number
---@return string if no name for tab, return empty string
function tab_name.get_raw(tabid)
  if tabid == 0 then
    tabid = api.get_current_tab()
  end
  if tab_names[tabid] ~= nil then
    return tab_names[tabid]
  end
  return ''
end

---save tab names to vim global variable.
---convert tabid to tab number, and save to TabbyTabNames
function tab_name.save()
  local names_to_number = {} ---@type table<number, string>
  for tabid, name in pairs(tab_names) do
    local tab_num = api.get_tab_number(tabid)
    names_to_number[tab_num] = name
  end
  vim.g.TabbyTabNames = vim.json.encode(names_to_number)
end

---load tab names from vim global variable.
function tab_name.load()
  local names_to_number, ok = pcall(vim.json.decode, vim.g.TabbyTabNames)
  if not (ok and type(names_to_number) == 'table') then
    return
  end
  for _, tabid in ipairs(api.get_tabs()) do
    local tab_num = api.get_tab_number(tabid)
    if names_to_number[tab_num] ~= nil then
      tab_names[tabid] = names_to_number[tab_num]
    end
  end
end

return tab_name
