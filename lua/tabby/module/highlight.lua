local highlight = {}

vim.cmd([[
  augroup highlight_cache
    autocmd!
    autocmd ColorScheme * lua require("tabby.module.highlight").clear_extract_cache()
  augroup end
]])

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
    cterm = { hl.cterm, 'string', true },
    ctermfg = { hl.ctermfg, 'string', true },
    ctermbg = { hl.ctermbg, 'string', true },
  })
  local tabby_keys = { 'fg', 'bg', 'style', 'cterm', 'ctermfg', 'ctermbg' }
  local nvim_keys = { 'guifg', 'guibg', 'gui', 'cterm', 'ctermfg', 'ctermbg' }

  local groups = { 'TabbyHL' }
  for _, k in ipairs(tabby_keys) do
    groups[#groups + 1] = hl[k] or ''
  end
  local group = table.concat(groups)
  if group == 'TabbyHl______' then -- all param is empty, return Normal
    return 'Normal'
  end
  if registered_highlight[group] == true then
    return group
  end

  local cmds = { 'hi', group }
  for i, k in ipairs(tabby_keys) do
    if hl[k] ~= nil then
      cmds[#cmds + 1] = string.format('%s=%s', nvim_keys[i], hl[k])
    end
  end
  vim.cmd(table.concat(cmds, ' '))
  registered_highlight[group] = true
  return group
end

---@type table<string, HighlightOpt>
local extract_cache = {}

---@param group_name string
---@return HighlightOpt
function highlight.extract(group_name)
  local ho = extract_cache[group_name]
  if ho ~= nil then
    return ho
  end
  local hl_str = vim.api.nvim_exec('highlight ' .. group_name, true)
  local hl = {}
  local map = { guifg = 'fg', guibg = 'bg', gui = 'style', cterm = 'cterm', ctermfg = 'ctermfg', ctermbg = 'ctermbg' }
  for k, v in string.gmatch(hl_str, '([^%s=]+)=([^%s=]+)') do
    if map[k] ~= nil then
      hl[map[k]] = v
    end
  end
  return hl
end

function highlight.clear_extract_cache()
  extract_cache = {}
end

return highlight
