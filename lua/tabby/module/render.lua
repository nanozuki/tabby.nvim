local log = require('tabby.module.log')
local highlight = require('tabby.module.highlight')

local render = {}

---@class Context
---@field parent_hl TabbyHighlight
---@field current_hl TabbyHighlight

---render node to tabline string
---@param node TabbyNode
---@param ctx Context? highlight group in context
---@return string, Context? rendered string and context
function render.node(node, ctx)
  if ctx ~= nil then
    vim.validate({
      ['ctx.current_hl'] = { ctx.current_hl, { 'string', 'table' }, true },
      ['ctx.parent_hl'] = { ctx.parent_hl, { 'string', 'table' }, true },
    })
  end
  if vim.tbl_islist(node) then
    local strs = {}
    for i, frag in ipairs(node) do
      strs[i], ctx = render.frag(frag, ctx)
    end
    return table.concat(strs, ''), ctx
  else
    return render.frag(node, ctx)
  end
end

---render frag to string
---@param frag TabbyFrag
---@param ctx Context? highlight group in context
---@return string, Context? rendered string and context
function render.frag(frag, ctx)
  if ctx ~= nil then
    vim.validate({
      ['ctx.current_hl'] = { ctx.current_hl, { 'string', 'table' }, true },
      ['ctx.parent_hl'] = { ctx.parent_hl, { 'string', 'table' }, true },
    })
  end
  if type(frag) == 'table' then
    return render.element(frag, ctx)
  elseif type(frag) == 'string' then
    return frag, ctx
  else
    log.error.format('invalid frag for tabby: %s', vim.inspect(frag))
    return '', ctx
  end
end

---render Element to string
---@param el TabbyElement
---@param ctx Context? highlight group in context
---@return string, Context? rendered string and context
function render.element(el, ctx)
  ctx = ctx or {}
  vim.validate({
    el = { el, 'table' },
    ['ctx.current_hl'] = { ctx.current_hl, { 'string', 'table' }, true },
    ['ctx.parent_hl'] = { ctx.parent_hl, { 'string', 'table' }, true },
  })
  local hl = el.hl or ctx.parent_hl
  local text = render.node(el[1], { current_hl = hl, parent_hl = hl })
  if hl ~= nil and hl ~= ctx.current_hl then
    text = render.highlight(hl, text)
    ctx.current_hl = hl
  end
  if el.lo ~= nil then
    text = render.layout(el.lo, text)
  end
  if el.click ~= nil then
    text = render.click_handler(el.click, text)
  end
  return text, ctx
end

---render highlight
---@param hl TabbyHighlight
---@param text string
---@return string
function render.highlight(hl, text)
  vim.validate({
    hl = { hl, { 'string', 'table' } },
    text = { text, 'string' },
  })
  ---@type string
  local group
  if type(hl) == 'string' then
    group = hl
  elseif type(hl) == 'table' then
    group = highlight.register(hl)
  end
  return string.format('%%#%s#', group) .. text
end

---render Layout
---@param lo TabbyLayout
---@param text string
---@return string
function render.layout(lo, text)
  vim.validate({
    lo = { lo, 'table' },
    text = { text, 'string' },
    ['lo.justify'] = { lo.justify, 'boolean', true },
    ['lo.min_width'] = { lo.min_width, 'number', true },
    ['lo.max_width'] = { lo.max_width, 'number', true },
  })
  if (lo.max_width or 0 == 0) and (lo.min_width or 0 == 0) then
    return text
  end

  -- text is: %-{min_width}.{maxwid}(<string>%)
  local head = '%-'
  local width = ''
  if (lo.justify or 'left') == 'right' then
    head = '%'
  end
  if (lo.max_width or 0) > 0 then
    width = string.format('%d.%d', lo.min_width or 0, lo.max_width or 0)
  elseif (lo.min_width or 0) > 0 then
    width = tostring(lo.min_width)
  end
  return table.concat({ head, width, '(', text, '%)' })
end

---render click handler to string
---@param click TabbyClickHandler
---@param text string
---@return string
function render.click_handler(click, text)
  vim.validate({
    click = { click, 'table' },
    ['click[1]'] = { click[1], 'string' },
    ['click[2]'] = { click[2], 'number' },
    text = { text, 'string' },
  })
  local prefix, suffix
  if click[1] == 'to_tab' then
    local number = vim.api.nvim_tabpage_get_number(click[2])
    prefix = '%' .. tostring(number) .. 'T'
    suffix = '%T'
  elseif click[1] == 'x_tab' then
    local number = vim.api.nvim_tabpage_get_number(click[2])
    prefix = '%' .. tostring(number) .. 'X'
    suffix = '%X'
  elseif click[1] == 'customer' then
    prefix = '%' .. click[2] .. '@TabbyCustomClickHandler@'
    suffix = '%X'
  end
  return string.format('%s%s%s', prefix, text, suffix)
end

return render
