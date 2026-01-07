local highlight = {}

---@alias TabbyHighlight TabbyHighlightGroup|TabbyHighlightObject

---@alias TabbyHighlightGroup string

---@class TabbyHighlightObject
---@field fg? string|number highlight argument guifg
---@field bg? string|number highlight argument guibg
---@field style? string highlight argument gui

local attrlist = {
  'bold',
  'underline',
  'undercurl',
  'underdouble',
  'underdotted',
  'underdashed',
  'strikethrough',
  'reverse',
  'italic',
}

---@param group_name string
---@param hl TabbyHighlightObject
local function set_hl(group_name, hl)
  local val = {}
  if hl.fg ~= nil then
    val.fg = hl.fg
  end
  if hl.bg ~= nil then
    val.bg = hl.bg
  end
  if hl.style ~= nil then
    for _, k in ipairs(attrlist) do
      if hl.style == k then
        val[k] = true
        break
      end
    end
  end
  vim.api.nvim_set_hl(0, group_name, val)
end

---@param group_name string
---@return TabbyHighlightObject
local function get_hl(group_name)
  local nvim_hl = vim.api.nvim_get_hl(0, { name = group_name, link = false })
  local hl = { fg = nvim_hl.fg, bg = nvim_hl.bg }
  for _, k in ipairs(attrlist) do
    if nvim_hl[k] then
      hl.style = k
      break
    end
  end
  return hl
end

---@type table<string, TabbyHighlightObject>
local extract_cache = {}

function highlight.clear_cache()
  extract_cache = {}
end

vim.api.nvim_create_autocmd({ 'ColorScheme' }, {
  pattern = { '*' },
  callback = highlight.clear_cache,
})

---register highlight object to nvim
---@param hl TabbyHighlightObject
---@return string highlight group name
function highlight.register(hl)
  if vim.fn.has('nvim-0.11.2') == 1 then
    vim.validate('fg', hl.fg, { 'string', 'number' }, true)
    vim.validate('bg', hl.bg, { 'string', 'number' }, true)
    vim.validate('style', hl.style, 'string', true)
  else
    vim.validate({
      fg = { hl.fg, { 'string', 'number' }, true },
      bg = { hl.bg, { 'string', 'number' }, true },
      style = { hl.style, 'string', true },
    })
  end

  local groups = { 'TabbyHL', hl.fg or 'NONE', hl.bg or 'NONE', hl.style or 'NONE' }
  local group = string.gsub(table.concat(groups, '_'), '#', '')

  set_hl(group, hl)
  extract_cache[group] = hl
  return group
end

---@param group_name string
---@return TabbyHighlightObject
function highlight.extract(group_name)
  if extract_cache[group_name] ~= nil then
    return extract_cache[group_name]
  end
  local hl = get_hl(group_name)
  extract_cache[group_name] = hl
  return hl
end

return highlight
