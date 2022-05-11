local text = {}

local highlight = require('tabby.module.highlight')

---separator
---@param sep string
---@param current Highlight
---@param parent Highlight
---@return Node
function text.separator(sep, current, parent)
  if type(current) == 'string' then
    current = highlight.extract(current)
  end
  if type(parent) == 'string' then
    parent = highlight.extract(parent)
  end
  return {
    sep,
    hl = {
      fg = current.bg,
      bg = parent.bg,
    },
  }
end

return text
