---@class HighlightObj
---@field fg    string hex color for foreground
---@field bg    string hex color for background
---@field style string | "'bold'" | "'underline'" | "'italic'" | "'strikethrough'" string Highlight gui style

---@class Highlight
---@field name? string highlight group name
---@field obj? HighlightObj
local Highlight = {}
Highlight.__index = Highlight

---new Highlight from highlight group name
---@param name string
---@return Highlight
function Highlight:from(name)
  vim.validate({ name = { name, 'string' } })
  local o = { name = name }
  return setmetatable(o, self)
end

---new Highlight from highlight obj
---@param obj HighlightObj
---@return Highlight
function Highlight:new(obj)
  vim.validate({
    obj = { obj, 'table' },
    ['obj.fg'] = { obj.fg, 'string', true },
    ['obj.bg'] = { obj.bg, 'string', true },
    ['obj.style'] = { obj.style, 'string', true },
  })
  return setmetatable({ obj = obj }, self)
end

---@type table<string, HighlightObj>
local stores = {}

---set highlight to vim
---@param h Highlight
---@return string
local function set_highlight(h)
  if h.name ~= nil and h.name ~= '' then
    return h.name
  end
  local fg, bg, style = h.obj.fg, h.obj.bg, h.obj.style
  h.name = string.gsub(string.format('TabbyHl_%s_%s_%s', fg, bg, style), '#', '')
  local cmd = { 'hi', h.name }
  if fg ~= nil and fg ~= '' then
    table.insert(cmd, 'guifg=' .. fg)
  end
  if bg ~= nil and bg ~= '' then
    table.insert(cmd, 'guibg=' .. bg)
  end
  if style ~= nil and style ~= '' then
    table.insert(cmd, 'gui=' .. style)
  end
  local hl_str = table.concat(cmd, ' ')
  vim.cmd(hl_str)
  stores[h.name] = h.obj
  return h.name
end

---get hl obj from group name
---@param h Highlight
local function extract_obj(h)
  if h.obj ~= nil then
    return
  end
  local obj = stores[h.name]
  if obj ~= nil then
    h.obj = obj
    return
  end
  local hl_str = vim.api.nvim_exec('highlight ' .. h.name, true)
  h.obj = {
    fg = hl_str:match('guifg=(#[0-9A-Fa-f]+)'),
    bg = hl_str:match('guibg=(#[0-9A-Fa-f]+)'),
    style = hl_str:match('gui=(#[0-9A-Fa-f]+)'),
  }
end

---set background
---@param color string
---@return Highlight
function Highlight:bg(color)
  vim.validate({ color = { color, 'string' } })
  extract_obj(self)
  self.obj.bg = color
end

---set foreground
---@param color string
---@return Highlight
function Highlight:fg(color)
  vim.validate({ color = { color, 'string' } })
  extract_obj(self)
  self.obj.bg = color
end

---set style
---@param style string
---@return Highlight
function Highlight:style(style)
  vim.validate({ style = { style, 'string' } })
  extract_obj(self)
  self.obj.style = style
end

---get highlight for outline
---@param parent Highlight
---@return Highlight
function Highlight:outline(parent)
  return {
    obj = {
      fg = self.obj.bg,
      bg = parent.obj.bg,
    },
  }
end

---get highlight for border
---@param accent string accent coloe
---@return Highlight
function Highlight:border(accent)
  vim.validate({ accent = { accent, 'string' } })
  return {
    obj = {
      fg = accent,
      bg = self.obj.bg,
    },
  }
end

---render text
---@param text string
---@return string
function Highlight:render(text)
  vim.validate({ text = { text, 'string' } })
  local name = set_highlight(self)
  return string.format('$$#%s#%s', name, text)
end

return Highlight
