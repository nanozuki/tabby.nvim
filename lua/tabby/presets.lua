local filename = require('tabby.filename')
local util = require('tabby.util')

local hl_tabline = util.extract_nvim_hl('TabLine')
local hl_normal = util.extract_nvim_hl('Normal')
local hl_tabline_sel = util.extract_nvim_hl('TabLineSel')
local hl_tabline_fill = util.extract_nvim_hl('TabLineFill')

---@type table<TabbyTablineLayout, TabbyTablineOpt>
local presets = {
  active_wins_at_tail = {
    hl = 'TabLineFill',
    layout = 'active_wins_at_tail',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
      { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    active_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    },
    inactive_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    top_win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    tail = {
      { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
    },
  },
  active_wins_at_end = {
    hl = 'TabLineFill',
    layout = 'active_wins_at_end',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
      { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    active_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
    },
    inactive_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    },
    top_win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
  },
  active_tab_with_wins = {
    hl = 'TabLineFill',
    layout = 'active_tab_with_wins',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'italic' } },
      { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    active_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
    },
    inactive_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    },
    top_win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
  },
  tab_with_top_win = {
    hl = 'TabLineFill',
    layout = 'tab_with_top_win',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'italic' } },
      { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    active_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_normal.bg, bg = hl_tabline_fill.bg } },
    },
    inactive_tab = {
      label = function(tabid)
        return {
          '  ' .. vim.api.nvim_tabpage_get_number(tabid) .. ' ',
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    },
    active_win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    win = {
      label = function(winid)
        return {
          '  ' .. filename.unique(winid) .. ' ',
          hl = 'TabLine',
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
  },
  tab_only = {
    hl = 'TabLineFill',
    layout = 'tab_only',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg } },
      { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
    active_tab = {
      label = function(tabid)
        local tabnum = vim.api.nvim_tabpage_get_number(tabid)
        local focus = vim.api.nvim_tabpage_get_win(tabid)
        local focus_name = filename.unique(focus)
        if vim.api.nvim_win_get_config(focus).relative ~= '' then
          focus_name = '[Floating]'
        end
        local append = ''
        local length = #(util.tabpage_list_wins(tabid))
        length = length - 1
        if length > 0 then
          append = ' [' .. length .. '+]'
        end
        return {
          ' ' .. tabnum .. ' / ' .. focus_name .. append .. ' ',
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline_sel.bg, bg = hl_tabline_fill.bg } },
    },
    inactive_tab = {
      label = function(tabid)
        local tabnum = vim.api.nvim_tabpage_get_number(tabid)
        local focus = vim.api.nvim_tabpage_get_win(tabid)
        local focus_name = filename.unique(focus)
        if vim.api.nvim_win_get_config(focus).relative ~= '' then
          focus_name = '[Floating]'
        end
        local append = ''
        local length = #(util.tabpage_list_wins(tabid))
        length = length - 1
        if length > 0 then
          append = ' [' .. length .. '+]'
        end
        return {
          ' ' .. tabnum .. ' / ' .. focus_name .. append .. ' ',
          hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'bold' },
        }
      end,
      left_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
      right_sep = { '', hl = { fg = hl_tabline.bg, bg = hl_tabline_fill.bg } },
    },
  },
}

return presets
