local element = {}

---@class LegacyText
---@field [1] string|fun():string text content
---@field hl? TabbyHighlight
---@field lo? TabbyLayout

local text_defaults = {
  '',
  hl = '',
  lo = {},
}

--- render text object to statusline text
---@param text string|LegacyText
---@return string statusline string
function element.render_text(text)
  if type(text) == 'string' then
    return text
  end
  text = vim.tbl_extend('force', text_defaults, text)
  local content = text[1] or ''
  if type(content) == 'function' then
    content = content()
  end
  if content == '' then
    return ''
  end
  local hl = element.render_highlight(text.hl)
  local pre, suf = element.render_layout(text.lo)
  return table.concat({ pre, hl, content, suf })
end

---@return string statusline string
function element.render_spring()
  return '%='
end

return element
