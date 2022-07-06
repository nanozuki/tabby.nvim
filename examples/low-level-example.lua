local colors = require('tabby.module.colors')
local tab = require('tabby.tab')
local text = require('tabby.text')

local hl_head = { fg = colors.black(), bg = colors.red(), style = 'italic' }
local hl_tabline = 'TabLineSel'
local hl_normal = { fg = colors.black(), bg = colors.white() }
local hl_tabline_sel = { fg = colors.black(), bg = colors.magenta(), style = 'bold' }
local hl_tabline_fill = 'TabLineFill'

local components = function()
  local coms = {
    { type = 'text', text = { '  ', hl = hl_head } },
    { type = 'text', text = text.separator('', hl_head, hl_tabline_fill) },
  }
  local tabs = vim.api.nvim_list_tabpages()
  local current_tab = vim.api.nvim_get_current_tabpage()
  for _, tabid in ipairs(tabs) do
    if tabid == current_tab then
      table.insert(coms, {
        type = 'tab',
        tabid = tabid,
        label = {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = hl_tabline_sel,
        },
        left_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
        right_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
      })
      local wins = tab.all_wins(current_tab)
      local top_win = vim.api.nvim_tabpage_get_win(current_tab)
      for _, winid in ipairs(wins) do
        local icon = '  '
        if winid == top_win then
          icon = '  '
        end
        local bufid = vim.api.nvim_win_get_buf(winid)
        local buf_name = vim.api.nvim_buf_get_name(bufid)
        table.insert(coms, {
          type = 'win',
          winid = winid,
          label = {
            table.concat({ '', icon, vim.fn.fnamemodify(buf_name, ':~:.'), '' }, ' '),
            hl = hl_normal,
          },
          left_sep = text.separator('', hl_normal, hl_tabline_fill),
          right_sep = text.separator('', hl_normal, hl_tabline_fill),
        })
      end
    else
      table.insert(coms, {
        type = 'tab',
        tabid = tabid,
        label = {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = hl_tabline,
        },
        left_sep = text.separator('', hl_tabline, hl_tabline_fill),
        right_sep = text.separator('', hl_tabline, hl_tabline_fill),
      })
    end
  end
  -- empty space in line
  table.insert(coms, { type = 'text', text = { '', hl = 'TabLineFill' } })

  return coms
end

require('tabby').setup({
  components = components,
})
