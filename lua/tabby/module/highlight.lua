local highlight = {}

---@alias TabbyHighlight TabbyHighlightGroup|TabbyHighlightObject

---@alias TabbyHighlightGroup string

---@class TabbyHighlightObject
---@field fg? string highlight argument guifg
---@field bg? string highlight argument guibg
---@field style? string highlight argument gui

vim.cmd([[
  augroup highlight_cache
    autocmd!
    autocmd ColorScheme * lua require("tabby.module.highlight").clear_extract_cache()
  augroup end
]])

---@type table<string,boolean>
local registered_highlight = {}

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
  if registered_highlight[group] == true then
    return group
  end

  local cmds = { 'hi', group }
  for i, k in ipairs(tabby_keys) do
    if hl[k] ~= nil then
      cmds[#cmds + 1] = string.format('%s=%s', nvim_keys[i], hl[k])
    end
  end
  if #cmds == 2 then
    cmds[#cmds + 1] = 'cleared'
  end
  vim.cmd(table.concat(cmds, ' '))
  registered_highlight[group] = true
  return group
end

---@type table<string, TabbyHighlightObject>
local extract_cache = {}

---@param group_name string
---@return TabbyHighlightObject
function highlight.extract(group_name)
  local ho = extract_cache[group_name]
  if ho ~= nil then
    return ho
  end
  local hl_str = vim.api.nvim_exec('highlight ' .. group_name, true)
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

function highlight.clear_extract_cache()
  extract_cache = {}
end

return highlight
