local filename = require('tabby.module.filename')
local highlight = require('tabby.module.highlight')

local hl_tabline = highlight.extract('TabLine')
local hl_tabline_sel = highlight.extract('TabLineSel')

---@type TabbyTablineOpt
local tabline = {
  hl = 'TabLineFill',
  layout = 'active_wins_at_tail',
  active_tab = {
    label = function(tabid)
      return {
        '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. '  ',
        hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
      }
    end,
    right_sep = { ' ', hl = 'TabLineFill' },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. '  ',
        hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'bold' },
      }
    end,
    right_sep = { ' ', hl = 'TabLineFill' },
  },
  top_win = {
    label = function(winid)
      return {
        ' > ' .. filename.unique(winid) .. ' ',
        hl = 'TabLine',
      }
    end,
    left_sep = { ' ', hl = 'TabLineFill' },
  },
  win = {
    label = function(winid)
      return {
        ' - ' .. filename.unique(winid) .. ' ',
        hl = 'TabLine',
      }
    end,
    left_sep = { ' ', hl = 'TabLineFill' },
  },
}

require('tabby').setup({
  tabline = tabline,
})
