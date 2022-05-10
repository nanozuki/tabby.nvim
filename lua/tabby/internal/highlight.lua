local highlight = {}

---@type table<string,boolean>
local registered_highlight = {}

---register highlight object to nvim
---@param hl HighlightOpt
---@return string highlight group name
function highlight.register(hl)
  vim.validate({
    fg = { hl.fg, 'string', true },
    bg = { hl.bg, 'string', true },
    style = { hl.style, 'string', true },
  })
  local group = string.gsub(string.format('TabbyHl_%s_%s_%s', hl.fg or '', hl.bg or '', hl.style or ''), '#', '')
  if registered_highlight[group] == true then
    return group
  end
  local cmd = { 'hi', group }
  if hl.fg ~= nil then
    table.insert(cmd, 'guifg=' .. hl.fg)
  end
  if hl.bg ~= nil then
    table.insert(cmd, 'guibg=' .. hl.bg)
  end
  if hl.style ~= nil then
    table.insert(cmd, 'gui=' .. hl.style)
  end
  vim.cmd(table.concat(cmd, ' '))
  registered_highlight[group] = true
  return group
end

return highlight
