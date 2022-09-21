local tab = {}

local api = require('tabby.module.api')
local tab_name = require('tabby.feature.tab_name')
local tabwins = require('tabby.feature.tabwins')

---set tab option
---@param opt TabbyTabNameOption
function tab.set_option(opt)
  tab_name.set_default_option(opt)
end

---list all tab id
---@deprecated use require('tabby.module.api').get_tabs()
---@return number[]
function tab.all()
  return api.get_tabs()
end

---return tab id of current tab
---@deprecated use require('tabby.module.api').get_current_tab()
---@return number tabid
function tab.get_current_tab()
  return api.get_current_tab()
end

---return current win id of the tab
---@deprecated use require('tabby.module.api').get_tab_current_win()
---@param tabid number
---@return number tab id for current tab
function tab.get_current_win(tabid)
  return api.get_tab_current_win(tabid)
end

---return all wins in tab
---@deprecated use require('tabby.module.api').get_tab_wins(tabid)
---@param tabid number
---@return number[]
function tab.all_wins(tabid)
  return api.get_tab_wins(tabid)
end

---return if this tab is current tab
---@deprecated use: tabid == require('tabby.module.api').get_current_tab(tabid), or tab.is_current()
---@param tabid number
---@return boolean
function tab.is_current(tabid)
  return tabid == api.get_current_tab()
end

---get tab's number, aka index in tabline
---@deprecated use: require('tabby.module.api').get_tab_number(tabid), or tab.name()
---@param tabid any
---@return number
function tab.get_number(tabid)
  return api.get_tab_number(tabid)
end

---set tab name
---@deprecated use require('tabby.feature.tab_name').set(tabid, name)
---@param tabid number
---@param name string
function tab.set_name(tabid, name)
  tab_name.set(tabid, name)
end

---set current tab name
---@deprecated use require('tabby.feature.tab_name').set(0, name)
---@param name string
function tab.set_current_name(name)
  tab_name.set(0, name)
end

---get tab's name
---@deprecated use require('tabby.feature.tab_name').get(tabid)
---@param tabid number
---@return string
function tab.get_name(tabid)
  return tab_name.get(tabid)
end

---get tab's raw name
---@deprecated use require('tabby.feature.tab_name').get_raw(tabid)
---@param tabid number
---@return string
function tab.get_raw_name(tabid)
  return tab_name.get_raw(tabid)
end

---return tab's close button
---@deprecated use tab.close_btn(symbol)
---@param tabid number
---@param symbol string
---@return TabbyNode
function tab.close_btn(tabid, symbol)
  return tabwins.new_tab(tabid, {}).close_btn(symbol)
end

return tab
