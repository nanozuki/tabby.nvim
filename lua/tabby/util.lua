local util = {}

---@deprecated use require('tabby.module.highlight').extract
---@param name string
---@return TabbyHighlightObject
function util.extract_nvim_hl(name)
  return require('tabby.module.highlight').extract(name)
end

---list all fixed wins
---@deprecated use require('tabby.module.api').get_wins
---@return number[] array of window ids
function util.list_wins()
  return require('tabby.module.api').get_wins()
end

---list all fixed wins of tab
---@deprecated use require('tabby.module.api').get_tab_wins
---@return number[] array of window ids
function util.tabpage_list_wins(tabid)
  return require('tabby.module.api').get_tab_wins(tabid)
end

---@deprecated use require('tabby.feature.tab_name').set(tabid, name)
---@param tabid number
---@param name string
function util.set_tab_name(tabid, name)
  require('tabby.feature.tab_name').set(tabid, name)
end

---get tab's name, if not set, will return the name made by fallback.
---@deprecated use require('tabby.feature.tab_name').get(tabid)
---@param tabid number
---@param fallback? fun(tabid:number):string Default fallback is like "init.lua[2+]", the filename is came from the focus window.
function util.get_tab_name(tabid, fallback)
  local tab_name = require('tabby.feature.tab_name')
  if fallback ~= nil then
    tab_name.set_option({
      name_fallback = fallback,
    })
  end
  return require('tabby.feature.tab_name').get(tabid)
end

--- conbine texts
---@deprecated use TabbyNode.margin
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
