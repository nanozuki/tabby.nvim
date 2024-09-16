local highlight = require('tabby.module.highlight')

---@class Tabby.LineBuilder
---@field strs string[]
---@field current_hl string
local LineBuilder = {}

---@return Tabby.LineBuilder
function LineBuilder:new()
  local o = { strs = {}, current_hl = '' }
  setmetatable(o, { __index = LineBuilder })
  return o
end

---@param s string
---@param hl? string
function LineBuilder:add(s, hl)
  if hl ~= nil and hl ~= self.current_hl then
    self.strs[#self.strs + 1] = string.format('%%#%s#', hl)
    self.current_hl = hl
  end
  self.strs[#self.strs + 1] = s
end

---@param s string
---@param hl? string
---@return fun()
function LineBuilder:lazy_add(s, hl)
  return function()
    self:add(s, hl)
  end
end

function LineBuilder:build()
  local line = table.concat(self.strs, '')
  self.strs = {}
  self.current_hl = ''
  return line
end

---@param click TabbyClickHandler
---@param heads fun()[]
---@param tails fun()[]
function LineBuilder:add_click(click, heads, tails)
  vim.validate({
    click = { click, 'table' },
    ['click[1]'] = { click[1], 'string' },
    ['click[2]'] = { click[2], 'number' },
  })
  if click[1] == 'to_tab' then
    local number = vim.api.nvim_tabpage_get_number(click[2])
    heads[#heads + 1] = self:lazy_add(string.format('%%%dT', number))
    tails[#tails + 1] = self:lazy_add('%T')
  elseif click[1] == 'x_tab' then
    local number = vim.api.nvim_tabpage_get_number(click[2])
    heads[#heads + 1] = self:lazy_add(string.format('%%%dX', number))
    tails[#tails + 1] = self:lazy_add('%X')
  elseif click[1] == 'to_buf' then
    local number = vim.fn.bufnr(click[2])
    heads[#heads + 1] = self:lazy_add(string.format('%%%d@TabbyOpenBuffer@', click[2]))
    tails[#tails + 1] = self:lazy_add('%X')
  elseif click[1] == 'customer' then
    heads[#heads + 1] = self:lazy_add(string.format('%%%d@TabbyCustomClickHandler@', click[2]))
    tails[#tails + 1] = self:lazy_add('%X')
  end
end

---render Layout
---@param lo TabbyLayout
---@param heads fun()[]
---@param tails fun()[]
function LineBuilder:add_layout(lo, heads, tails)
  vim.validate({
    lo = { lo, 'table' },
    ['lo.justify'] = { lo.justify, 'string', true },
    ['lo.min_width'] = { lo.min_width, 'number', true },
    ['lo.max_width'] = { lo.max_width, 'number', true },
  })
  -- text is: %-{min_width}.{maxwid}(<string>%)
  local head = ((lo.justify or 'left') == 'right') and '%' or '%-'
  local width = ''
  if (lo.max_width or 0) > 0 then
    width = string.format('%d.%d', lo.min_width or 0, lo.max_width or 0)
  elseif (lo.min_width or 0) > 0 then
    width = tostring(lo.min_width)
  end
  heads[#heads + 1] = self:lazy_add(string.format('%s%s(', head, width))
  tails[#tails + 1] = self:lazy_add('%)')
end

local function parse_highlight(hl)
  vim.validate({
    hl = { hl, { 'string', 'table' } },
  })
  local group ---@type string
  if type(hl) == 'string' then
    group = hl
  elseif type(hl) == 'table' then
    group = highlight.register(hl)
  end
  return group
end

---@param element TabbyElement
---@param heads fun()[]
---@return number number of added strs
function LineBuilder:render_element(element, heads)
  local hl_group = parse_highlight(element.hl)
  local tails = {} ---@type fun()[]
  local head_added = false
  local add = function(s, hl) -- add heads to builder if has real things to add
    if not head_added then
      if element.click ~= nil then
        self:add_click(element.click, heads, tails)
      end
      if element.lo ~= nil and (element.lo.max_width or 0 > 0 or element.lo.min_width or 0 > 0) then
        self:add_layout(element.lo, heads, tails)
      end
      for i, fn in ipairs(heads) do
        fn()
        heads[i] = nil
      end
      head_added = true
    end
    self:add(s, hl)
  end

  local beg = #self.strs
  local hasMargin = false

  for i, node in ipairs(element) do
    if type(node) == 'string' and node ~= '' then
      if element.margin and i ~= 1 then
        add(element.margin, hl_group)
      end
      add(node, hl_group)
    elseif type(node) == 'number' then
      if element.margin and i ~= 1 then
        add(element.margin, hl_group)
      end
      add(tostring(node), hl_group)
    elseif type(node) == 'table' then
      if (element.margin or '') ~= '' and i ~= 1 and not hasMargin then
        heads[#heads + 1] = self:lazy_add(element.margin, hl_group)
        hasMargin = true
      end
      ---@cast node TabbyElement
      if node.hl == nil then
        node.hl = hl_group
      end
      local n = self:render_element(node, heads)
      if n > 0 then
        hasMargin = false
      end
    end
  end

  for i = #tails, 1, -1 do
    tails[i]()
  end
  return #self.strs - beg
end

return LineBuilder
