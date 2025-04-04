local tab_name = {}

---@class TabbyTabNameOption
---@field name_fallback? fun(tabid:number):string
---@field override? fun(tabid:number):string?

local api = require('tabby.module.api')
local win_name = require('tabby.feature.win_name')

---@type TabbyTabNameOption
local default_option = {
  name_fallback = function(tabid)
    local wins = api.get_tab_wins(tabid)
    local cur_win = api.get_tab_current_win(tabid)
    local name = ''
    if api.is_float_win(cur_win) then
      name = '[Floating]'
    else
      name = win_name.get(cur_win)
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
---@type table<string, string>
local tab_names = {}

---set tab name
---@param tabid number tab id, 0 for current tab
---@param name string
function tab_name.set(tabid, name)
  if tabid == 0 then
    tabid = api.get_current_tab()
  end
  tab_names[tostring(tabid)] = name
  vim.cmd('redrawtabline')
end

---get tab's raw name
---@param tabid number
---@return string if no name for tab, return empty string
function tab_name.get_raw(tabid)
  if tabid == 0 then
    tabid = api.get_current_tab()
  end
  local name = tab_names[tostring(tabid)]
  if name ~= nil then
    return name
  end
  return ''
end

---get tab's name
---@param tabid number tab id, 0 for current tab
---@param opt? TabbyTabNameOption
---@return string
function tab_name.get(tabid, opt)
  local o = vim.tbl_deep_extend('force', default_option, opt or {})
  if o.override then
    local overrided = o.override(tabid)
    if overrided ~= nil then
      return overrided
    end
  end
  local raw_name = tab_name.get_raw(tabid)
  if raw_name ~= '' then
    return raw_name
  end
  return o.name_fallback(tabid)
end

---save tab names to vim global variable.
---convert tabid to tab number, and save to TabbyTabNames
local function save()
  local names_to_number = {} ---@type table<string, string>
  for tabid, name in pairs(tab_names) do
    local ok, tab_num = pcall(api.get_tab_number, tonumber(tabid))
    if ok then
      names_to_number[tostring(tab_num)] = name
    end
  end
  vim.g.TabbyTabNames = vim.json.encode(names_to_number)
end

---load tab names from vim global variable.
local function load()
  local ok, names_to_number = pcall(vim.json.decode, vim.g.TabbyTabNames)
  if not (ok and type(names_to_number) == 'table') then
    return
  end
  for _, tabid in ipairs(api.get_tabs()) do
    local tab_num = api.get_tab_number(tabid)
    local name = names_to_number[tostring(tab_num)]
    if name ~= nil then
      tab_names[tostring(tabid)] = name
    end
  end
end

local loaded = false

-- load tab names when session loaded, in case of session load after tabby
vim.api.nvim_create_autocmd({ 'SessionLoadPost' }, {
  pattern = '*',
  callback = function()
    loaded = false
  end,
})

---pre render hook, load and save tab names
function tab_name.pre_render()
  if not loaded then
    load()
    loaded = true
  else
    save()
  end
end

return tab_name
