local tab = {}

---set tab name
---@deprecated use require('tabby.feature.tab_name').set(tabid, name)
---@param tabid number
---@param name string
function tab.set_name(tabid, name)
  require('tabby.feature.tab_name').set(tabid, name)
end

---get tab's name
---@deprecated use require('tabby.feature.tab_name').get(tabid)
---@param tabid number
---@return string
function tab.get_name(tabid)
  return require('tabby.feature.tab_name').get(tabid)
end

return tab
