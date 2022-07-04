--- lowest level specs, can be render to statusline-format text directly

local node = require('tabby.module.node')
local render = require('tabby.module.render')

local component = {}

---@class TabbyComTab
---@field type "tab"
---@field tabid number
---@field label string|LegacyText
---@field left_sep? LegacyText
---@field right_sep? LegacyText

---@class TabbyComWin
---@field type "win"
---@field winid number
---@field label string|LegacyText
---@field left_sep? LegacyText
---@field right_sep? LegacyText

---@class TabbyComText
---@field type "text"
---@field text LegacyText

---@class TabbyComSpring
---@field type "spring"

---@alias TabbyComponent TabbyComTab|TabbyComWin|TabbyComText|TabbyComSpring

---@param tab TabbyComTab
---@return Node
local function render_tab(tab)
  return {
    node.from_label_and_seps(tab.label, tab.left_sep, tab.right_sep),
    click = { 'to_tab', tab.tabid },
  }
end

---@param win TabbyComWin
---@return Node
local function render_win(win)
  return node.from_label_and_seps(win.label, win.left_sep, win.right_sep)
end

---@param text TabbyComText
---@return Node
local function render_text(text)
  return node.from_tabby_text(text.text)
end

---@return string statusline-format string
local function render_spring()
  return '%='
end

---@param com TabbyComponent
---@return string statusline-format string
function component.render(com)
  ---@type Node
  local n
  if com.type == 'tab' then
    n = render_tab(com)
  elseif com.type == 'win' then
    n = render_win(com)
  elseif com.type == 'text' then
    n = render_text(com)
  elseif com.type == 'spring' then
    n = render_spring()
  else
    error('invalid component type')
  end
  return render.node(n)
end

return component
