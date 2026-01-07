local log = require('tabby.module.log')
local highlight = require('tabby.module.highlight')

local render = {}

---@class TabbyRendererContext
---@field parent_hl TabbyHighlight highlight for callback
---@field current_hl TabbyHighlight highlight for render

--[[markdown
# Renderer note

recursive rendering

## Termination Condition
* nil -> skip.
* RawElement: { <string,number>, hl=<hl>, lo=<lo> } -> vim status line context

## Raw Content
convert to raw element
* <string,number> -> { <string,number>, hl=ctx.parent_hl }

## nested structure
* list fragment: { 'string', 10, <Element> } }
  -> render every item, and table.concat
* element with element content: { <element>, hl=<hl>, lo=<lo> }
  -> render every item, with context { parent_hl = <hl> }
* element with list content: { {<any>, <any>, <any>}, hl=<hl>, lo=<lo> }
  -> render every item, with context { parent_hl = <hl> }
--]]

local function is_list(tbl)
  if vim.fn.has('nvim-0.10') == 1 then
    return vim.islist(tbl)
  else
    ---@diagnostic disable-next-line: deprecated
    return vim.tbl_islist(tbl)
  end
end

---render node to tabline string
---@param node TabbyNode
---@param ctx TabbyRendererContext? highlight group in context
---@return string, TabbyRendererContext rendered string and context
function render.node(node, ctx)
  if ctx ~= nil then
    if vim.fn.has('nvim-0.11.2') == 1 then
      vim.validate('node', node, { 'string', 'number', 'table' }, true)
      vim.validate('ctx.current_hl', ctx.current_hl, { 'string', 'table' }, true)
      vim.validate('ctx.parent_hl', ctx.parent_hl, { 'string', 'table' }, true)
    else
      vim.validate({
        node = { node, { 'string', 'number', 'table' }, true },
        ['ctx.current_hl'] = { ctx.current_hl, { 'string', 'table' }, true },
        ['ctx.parent_hl'] = { ctx.parent_hl, { 'string', 'table' }, true },
      })
    end
  end
  ctx = ctx or {}
  if type(node) == 'nil' then
    return '', ctx
  elseif type(node) == 'string' or type(node) == 'number' then
    ---@diagnostic disable-next-line: assign-type-mismatch
    return render.raw_element({ node, hl = ctx.parent_hl }, ctx)
  else -- type(node) == 'table'
    if is_list(node) then
      local strs = {}
      for i, sub in ipairs(node) do
        log.debug.format('render sub-node[%d]: %s', i, log.inspect(sub))
        local s, c = render.node(sub, ctx)
        if s ~= '' then
          strs[#strs + 1], ctx = s, c
        end
      end
      return table.concat(strs, ''), ctx
    else
      log.debug.format('render non-listed-node: %s', log.inspect(node))
      return render.hyper_element(node, ctx)
    end
  end
end

---render element with raw content
---@param el string|number|TabbyElement
---@param ctx TabbyRendererContext
---@return string, TabbyRendererContext nvim statusline-styled string
function render.raw_element(el, ctx)
  ctx = ctx or {}
  if vim.fn.has('nvim-0.11.2') == 1 then
    vim.validate('el', el, 'table')
    vim.validate('content', el[1], { 'string', 'number' })
    vim.validate('ctx.current_hl', ctx.current_hl, { 'string', 'table' }, true)
    vim.validate('ctx.parent_hl', ctx.parent_hl, { 'string', 'table' }, true)
  else
    vim.validate({
      el = { el, 'table' },
      content = { el[1], { 'string', 'number' } },
      ['ctx.current_hl'] = { ctx.current_hl, { 'string', 'table' }, true },
      ['ctx.parent_hl'] = { ctx.parent_hl, { 'string', 'table' }, true },
    })
  end
  local text = tostring(el[1])
  if el.click ~= nil then
    text = render.click_handler(el.click, text)
  end
  if el.lo ~= nil then
    text = render.layout(el.lo, text)
  end
  local hl = el.hl or ctx.parent_hl
  if hl ~= nil and hl ~= ctx.current_hl then
    text = render.highlight(hl, text)
    ctx.current_hl = hl
  end
  log.debug.format('render.raw_element( %s ) = %s', log.inspect(el), text)
  return text, ctx
end

---@param el TabbyElement
---@param ctx TabbyRendererContext
---@return string, TabbyRendererContext
function render.hyper_element(el, ctx)
  if #el == 1 and type(el[1]) ~= 'table' then
    return render.raw_element(el, ctx)
  end
  local strs = {}
  local inner_ctx = { current_hl = ctx.current_hl, parent_hl = el.hl or ctx.parent_hl }
  for i, sub in ipairs(el) do
    local s, c = render.node(sub, inner_ctx)
    if s ~= '' then
      strs[#strs + 1], inner_ctx = s, c
      if (el.margin or '') ~= '' and i ~= #el then
        ---@diagnostic disable-next-line: assign-type-mismatch
        strs[#strs + 1], inner_ctx = render.raw_element({ el.margin, hl = el.hl }, inner_ctx)
      end
    end
  end
  local inner_text = table.concat(strs, '')
  ctx.current_hl = inner_ctx.current_hl
  ---@diagnostic disable-next-line: assign-type-mismatch
  return render.raw_element({ inner_text, hl = el.hl, lo = el.lo, click = el.click, margin = el.margin }, ctx)
end

---render highlight
---@param hl TabbyHighlight
---@param text string
---@return string
function render.highlight(hl, text)
  if vim.fn.has('nvim-0.11.2') == 1 then
    vim.validate('hl', hl, { 'string', 'table' })
    vim.validate('text', text, 'string')
  else
    vim.validate({
      hl = { hl, { 'string', 'table' } },
      text = { text, 'string' },
    })
  end
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
  if vim.fn.has('nvim-0.11.2') == 1 then
    vim.validate('lo', lo, 'table')
    vim.validate('text', text, 'string')
    vim.validate('lo.justify', lo.justify, 'boolean', true)
    vim.validate('lo.min_width', lo.min_width, 'number', true)
    vim.validate('lo.max_width', lo.max_width, 'number', true)
  else
    vim.validate({
      lo = { lo, 'table' },
      text = { text, 'string' },
      ['lo.justify'] = { lo.justify, 'boolean', true },
      ['lo.min_width'] = { lo.min_width, 'number', true },
      ['lo.max_width'] = { lo.max_width, 'number', true },
    })
  end
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
  if vim.fn.has('nvim-0.11.2') == 1 then
    vim.validate('click', click, 'table')
    vim.validate('click[1]', click[1], 'string')
    vim.validate('click[2]', click[2], 'number')
    vim.validate('text', text, 'string')
  else
    vim.validate({
      click = { click, 'table' },
      ['click[1]'] = { click[1], 'string' },
      ['click[2]'] = { click[2], 'number' },
      text = { text, 'string' },
    })
  end
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
