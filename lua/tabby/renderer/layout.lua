local layout = {}

---@class TabbyLayout
---@field max_width number
---@field min_width number
---@field justify   "left"|"right" default is left

local layout_defaults = {
  max_width = nil,
  min_width = nil,
  justify = 'left',
}

function layout.render(text, lo)
  lo = vim.tbl_extend('force', layout_defaults, lo)
  if lo.max_width == nil and lo.min_width == nil then
    return text
  end

  -- text is: %-{minwid}.{maxwid}(<string>%)
  local head = ''
  if lo.justify == 'left' then
    head = '%-'
  else
    head = '%'
  end

  local width = ''
  if lo.max_width ~= nil and lo.min_width ~= nil then
    width = string.format('%d.%d', lo.min_width, lo.max_width)
  elseif lo.max_width ~= nil then
    width = '.' .. lo.max_width
  elseif lo.min_width ~= nil then
    width = lo.max_width .. '.'
  end
  return table.concat({ head, width, '(', text, '%)' })
end

return layout
