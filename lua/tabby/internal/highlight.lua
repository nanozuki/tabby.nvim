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
  if group == 'TabbyHl___' then -- all param is empty, return Normal
    return 'Normal'
  end
  if registered_highlight[group] == true then
    return group
  end
  local cmd = { 'hi', group }
  if hl.fg ~= nil and hl.fg ~= '' then
    table.insert(cmd, 'guifg=' .. hl.fg)
  end
  if hl.bg ~= nil and hl.bg ~= '' then
    table.insert(cmd, 'guibg=' .. hl.bg)
  end
  if hl.style ~= nil and hl.style ~= '' then
    table.insert(cmd, 'gui=' .. hl.style)
  end
  vim.cmd(table.concat(cmd, ' '))
  registered_highlight[group] = true
  return group
end

---@param group_name string
---@return HighlightOpt
function highlight.extract(group_name)
  local hl_str = vim.api.nvim_exec('highlight ' .. group_name, true)
  local hl = {
    fg = hl_str:match('guifg=([^%s]+)') or '',
    bg = hl_str:match('guibg=([^%s]+)') or '',
    style = hl_str:match('gui=([^%s]+)') or '',
  }
  return hl
end

return highlight
