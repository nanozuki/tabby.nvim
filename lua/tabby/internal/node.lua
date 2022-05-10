---A element is a "hyper text" object
---@class Element
---@field [1] Node children node
---@field hl Highlight
---@field lo Layout
---@field click ClickHandler

---@alias Highlight HighlightGroup|HighlightOpt

---@alias HighlightGroup string

---@class HighlightOpt
---@field fg?    string hex color for foreground
---@field bg?    string hex color for background
---@field style? string gui style attributes

---@class Layout
---@field justify? 'left'|'right' justify @default 'left'
---@field max_width? number maximum width
---@field min_width? number minimum width

---@alias ClickHandler ClickTab|CloseTab|CustomHander

---@class ClickTab
---@field [1] "to_tab"
---@field [2] number tabid

---@class CloseTab
---@field [1] "x_tab"
---@field [2] number tabid

---@class CustomHander
---@field [1] "custom"
---@field [2] number handle id

---@alias Frag Element|string
---@alias Node Frag|Frag[]

local node = {}

---convert legacy TabbyText to Element/Node
---@param ttext TabbyText
---@return table Element
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
---@param label string|TabbyText
---@param left_sep TabbyText?
---@param right_sep TabbyText?
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
