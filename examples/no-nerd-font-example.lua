local filename = require('tabby.filename')
local util = require('tabby.util')

local hl_tabline = util.extract_nvim_hl('TabLine')
local hl_tabline_sel = util.extract_nvim_hl('TabLineSel')

---@type TabbyTablineOpt
local tabline = {
  hl = 'TabLineFill',
  layout = 'active_wins_at_tail',
  active_tab = {
    label = function(tabid)
      return {
        '  ' .. tabid .. '  ',
        hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
      }
    end,
    right_sep = { ' ', hl = 'TabLineFill' },
  },
  inactive_tab = {
    label = function(tabid)
      return {
        '  ' .. tabid .. '  ',
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
