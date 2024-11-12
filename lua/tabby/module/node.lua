---@alias TabbyText string|number
---@alias TabbyNode TabbyElement|TabbyText

---A element is a "hyper text" object
---@class TabbyElement
---@field hl? TabbyHighlight
---@field lo? TabbyLayout
---@field click? TabbyClickHandler
---@field margin? string
---@field [...] TabbyNode children node

---@class TabbyLayout
---@field justify? 'left'|'right' justify @default 'left'
---@field max_width? number maximum width
---@field min_width? number minimum width

---@alias TabbyClickHandler TabbyClickTab|TabbyCloseTab|TabbyClickBuf|TabbyCustomHander

---@class TabbyClickTab
---@field [1] "to_tab"
---@field [2] number tabid

---@class TabbyCloseTab
---@field [1] "x_tab"
---@field [2] number tabid

---@class TabbyClickBuf
---@field [1] "to_buf"
---@field [2] number bufid

---@class TabbyCustomHander
---@field [1] "custom"
---@field [2] number handle id

local node = {}

---convert legacy TabbyText to Element/Node
---@param ttext LegacyText
---@return table TabbyElement
function node.from_tabby_text(ttext)
  if type(ttext[1]) == 'string' then
    return ttext
  else
    return {
      ttext[1](),
      hl = ttext.hl,
      lo = ttext.lo,
    }
  end
end

---convert (left_sep, label, right_sep) to Node
---@param label string|LegacyText
---@param left_sep LegacyText?
---@param right_sep LegacyText?
function node.from_label_and_seps(label, left_sep, right_sep)
  local elements = {}
  if left_sep ~= nil then
    elements[#elements + 1] = node.from_tabby_text(left_sep)
  end
  if type(label) == 'string' then
    elements[#elements + 1] = label
  else
    elements[#elements + 1] = node.from_tabby_text(label)
  end
  if right_sep ~= nil then
    elements[#elements + 1] = node.from_tabby_text(right_sep)
  end
  return elements
end

return node
