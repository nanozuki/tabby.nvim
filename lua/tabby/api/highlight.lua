---@class TabbyHighlight
---@field fg string foreground
---@field bg string background
---@field style string text style
local Highlight = {}

---@param hl TabbyHighlight
---@return TabbyHighlight new highlight group
function Highlight:new(hl)
  hl = hl or {}
  setmetatable(hl, self)
  self.__index = self
  return self
end

---create Highlight from a nvim highlight group name
---@param hl_group_name string highlight group name
---@return TabbyHighlight
function Highlight:from(hl_group_name)
  local hl_str = vim.api.nvim_exec('highlight ' .. hl_group_name, true)
  local hl = {
    fg = hl_str:match('guifg=(#[0-9A-Fa-f]+)') or '#444444',
    bg = hl_str:match('guibg=(#[0-9A-Fa-f]+)') or '#1E1E1E',
    style = hl_str:match('gui=(#[0-9A-Fa-f]+)') or '',
  }
  return Highlight:new(hl)
end

---@param self TabbyHighlight
---@param fg string foreground color
---@return TabbyHighlight
function Highlight:fg(fg)
  return {
    fg = fg,
    bg = self.bg,
    style = self.style,
  }
end

---@param self TabbyHighlight
---@param bg string foreground color
---@return TabbyHighlight
function Highlight:bg(bg)
  return {
    fg = bg,
    bg = self.bg,
    style = self.style,
  }
end

---@param self TabbyHighlight
---@param style string foreground color
---@return TabbyHighlight
function Highlight:style(style)
  return {
    fg = self.fg,
    bg = self.bg,
    style = style,
  }
end

---reverse foreground and background
---@param self TabbyHighlight
---@return TabbyHighlight
function Highlight:rev()
  return {
    fg = self.bg,
    bg = self.fg,
    style = self.style,
  }
end

---return the hl group of seprator in parent hl group
---@param self TabbyHighlight
---@param parent TabbyHighlight
---@return TabbyHighlight
function Highlight:sep(parent)
  return {
    fg = self.bg,
    bg = parent.bg,
  }
end

---return the hl group of border
---@param self TabbyHighlight
---@param color string border color
---@return TabbyHighlight
function Highlight:border(color)
  return {
    fg = color,
    bg = self.bg,
  }
end

function Highlight:__call(text)
  return text
end

return Highlight
