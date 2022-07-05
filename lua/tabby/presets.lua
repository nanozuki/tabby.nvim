local filename = require('tabby.module.filename')
local highlight = require('tabby.module.highlight')
local text = require('tabby.text')
local tab = require('tabby.tab')

local hl_tabline = highlight.extract('TabLine')
local hl_normal = highlight.extract('Normal')
local hl_tabline_sel = highlight.extract('TabLineSel')
local hl_tabline_fill = highlight.extract('TabLineFill')

local function tab_label(tabid, active)
  local icon = active and '' or ''
  local number = vim.api.nvim_tabpage_get_number(tabid)
  local name = tab.get_name(tabid)
  return string.format(' %s %d: %s ', icon, number, name)
end

local function tab_label_no_fallback(tabid, active)
  local icon = active and '' or ''
  local name = tab.get_raw_name(tabid)
  local number = vim.api.nvim_tabpage_get_number(tabid)
  if name == '' then
    return string.format(' %s %d ', icon, number)
  end
  return string.format(' %s %d: %s ', icon, number, name)
end

local function win_label(winid, top)
  local icon = top and '' or ''
  return string.format(' %s %s ', icon, filename.unique(winid))
end

local presets = {
  active_wins_at_tail = {
    hl = hl_tabline_fill,
    layout = 'active_wins_at_tail',
    head = {
      { '  ', hl = hl_tabline },
      text.separator('', hl_tabline, hl_tabline_fill),
    },
    active_tab = {
      label = function(tabid)
        return {
          tab_label(tabid, true),
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
    },
    inactive_tab = {
      label = function(tabid)
        return {
          tab_label(tabid),
          hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
    top_win = {
      label = function(winid)
        return {
          win_label(winid, true),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
    win = {
      label = function(winid)
        return {
          win_label(winid),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
    tail = {
      text.separator('', hl_tabline, hl_tabline_fill),
      { '  ', hl = hl_tabline },
    },
  },
  active_wins_at_end = {
    hl = hl_tabline_fill,
    layout = 'active_wins_at_end',
    head = {
      { '  ', hl = hl_tabline },
      text.separator('', hl_tabline, hl_tabline_fill),
    },
    active_tab = {
      label = function(tabid)
        return {
          tab_label(tabid, true),
          hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_normal, hl_tabline_fill),
      right_sep = text.separator('', hl_normal, hl_tabline_fill),
    },
    inactive_tab = {
      label = function(tabid)
        return {
          tab_label(tabid),
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
    },
    top_win = {
      label = function(winid)
        return {
          win_label(winid, true),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
    win = {
      label = function(winid)
        return {
          win_label(winid),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
  },
  active_tab_with_wins = {
    hl = hl_tabline_fill,
    layout = 'active_tab_with_wins',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'italic' } },
      text.separator('', hl_tabline, hl_tabline_fill),
    },
    active_tab = {
      label = function(tabid)
        return {
          tab_label(tabid, true),
          hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_normal, hl_tabline_fill),
      right_sep = text.separator('', hl_normal, hl_tabline_fill),
    },
    inactive_tab = {
      label = function(tabid)
        return {
          tab_label(tabid),
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
    },
    top_win = {
      label = function(winid)
        return {
          win_label(winid, true),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
    win = {
      label = function(winid)
        return {
          win_label(winid),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
  },
  tab_with_top_win = {
    hl = hl_tabline_fill,
    layout = 'tab_with_top_win',
    head = {
      { '  ', hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'italic' } },
      text.separator('', hl_tabline, hl_tabline_fill),
    },
    active_tab = {
      label = function(tabid)
        return {
          tab_label_no_fallback(tabid, true),
          hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_normal, hl_tabline_fill),
      right_sep = text.separator('', hl_normal, hl_tabline_fill),
    },
    inactive_tab = {
      label = function(tabid)
        return {
          tab_label_no_fallback(tabid),
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
    },
    active_win = {
      label = function(winid)
        return {
          win_label(winid, true),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
    win = {
      label = function(winid)
        return {
          win_label(winid),
          hl = 'TabLine',
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
  },
  tab_only = {
    hl = hl_tabline_fill,
    layout = 'tab_only',
    head = {
      { '  ', hl = hl_tabline },
      text.separator('', hl_tabline, hl_tabline_fill),
    },
    active_tab = {
      label = function(tabid)
        return {
          tab_label(tabid, true),
          hl = { fg = hl_tabline_sel.fg, bg = hl_tabline_sel.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline_sel, hl_tabline_fill),
    },
    inactive_tab = {
      label = function(tabid)
        return {
          tab_label(tabid, false),
          hl = { fg = hl_tabline.fg, bg = hl_tabline.bg, style = 'bold' },
        }
      end,
      left_sep = text.separator('', hl_tabline, hl_tabline_fill),
      right_sep = text.separator('', hl_tabline, hl_tabline_fill),
    },
  },
}

return presets
