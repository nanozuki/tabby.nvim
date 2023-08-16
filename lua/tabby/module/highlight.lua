local highlight = {}

---@alias TabbyHighlight TabbyHighlightGroup|TabbyHighlightObject

---@alias TabbyHighlightGroup string

---@class TabbyHighlightObject
---@field fg? string highlight argument guifg
---@field bg? string highlight argument guibg
---@field style? string highlight argument gui

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
  vim.validate({
    fg = { hl.fg, 'string', true },
    bg = { hl.bg, 'string', true },
    style = { hl.style, 'string', true },
  })
  local tabby_keys = { 'fg', 'bg', 'style' }
  local nvim_keys = { 'guifg', 'guibg', 'gui' }

  local groups = { 'TabbyHL' }
  for _, k in ipairs(tabby_keys) do
    groups[#groups + 1] = hl[k] or 'NONE'
  end
  local group = string.gsub(table.concat(groups, '_'), '#', '')

  local cmds = { 'hi', group }
  for i, k in ipairs(tabby_keys) do
    if hl[k] ~= nil then
      cmds[#cmds + 1] = string.format('%s=%s', nvim_keys[i], hl[k])
    end
  end
  if #cmds == 2 then
    cmds[#cmds + 1] = 'gui=NONE'
  end
  extract_cache[group] = hl
  vim.cmd(table.concat(cmds, ' '))
  return group
end

---@param group_name string
---@return TabbyHighlightObject
function highlight.extract(group_name)
  if extract_cache[group_name] ~= nil then
    return extract_cache[group_name]
  end
  local hl_str = vim.api.nvim_exec('highlight ' .. group_name, true)
  local links_to = string.match(hl_str, 'links to (.*)$')
  if links_to then
    local hl = highlight.extract(links_to)
    extract_cache[group_name] = hl
    return hl
  end
  local hl = {}
  for k, v in string.gmatch(hl_str, '([^%s=]+)=([^%s=]+)') do
    if k == 'guifg' then
      hl.fg = v
    elseif k == 'guibg' then
      hl.bg = v
    elseif k == 'gui' then
      hl.style = v
    end
  end
  extract_cache[group_name] = hl
  return hl
end

return highlight
