---@class NodeModule

---@type NodeModule
local node = {}

---A element is a "hyper text" object
---@class Element
---@field text string inner raw text in node
---@field hl Highlight
---@field lo Layout
---@field click ClickHandler

---@class Highlight
---@field fg   string foreground color
---@field bg   string background color
---@field attr string gui attributes

---@class Layout
---@field right boolean Is left justify @default false
---@field maxwid number maximum width
---@field minwid number minimum width

---@alias ClickHandler ClickTab|CloseTab|CustomerHander

---@class ClickTab
---@field [1] "to_tab"
---@field [2] number tabid

---@class CloseTab
---@field [1] "x_tab"
---@field [2] number tabid

---@class CustomerHander
---@field [1] "customer"
---@field [2] number handle id
---@field [3] function(number,string,string) handler

---@alias Frag Element|string
---@alias Node Frag|Frag[]

---render node to tabline string
---@param _ Node
---@return string
function node.render_to_tabline(_)
  -- TODO not implemented
end

return node
