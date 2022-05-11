---@class TablineModule
---@field renderer? fun():Node
---@field opt TablineOpt
---@field preset TablinePreset

---@class TablinePreset

---@type TablineModule
local tabline = {
  renderer = nil,
  opt = {
    show_at_least = 1,
  },
}

local text = require('tabby.text')
local tab = require('tabby.tab')
local win = require('tabby.win')

---@class TablineOpt
---@field show_at_least number show tabline when there are at least n tabs.

---set tabline render function
---@param fn fun():Node
---@param opt TablineOpt
function tabline.set(fn, opt)
  tabline.renderer = fn
  if opt ~= nil then
    tabline.opt = vim.tbl_extend('force', tabline.opt, opt)
  end
  vim.cmd([[
    augroup tabby_show_control
      autocmd!
      autocmd TabNew,TabClosed * lua require("tabby.tabline").show_contorl()
    augroup end
  ]])
  if vim.api.nvim_get_vvar('vim_did_enter') then
    tabline.init()
  else
    vim.cmd("au VimEnter * lua require'tabby.tabline'.init()")
  end
end

function tabline.init()
  tabline.show_control()
  vim.o.tabline = '%!TabbyRenderTabline()'
end

function tabline.render()
  require('tabby.filename').flush_unique_name_cache()
  return require('tabby.module.render').node(tabline.renderer)
end

function tabline.show_control()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs >= tabline.opt.show_at_least then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end

---@type TablinePreset
local preset = {}

function preset.active_wins_at_tail(opt)
  local renderer = function()
    return {
      { '  ', hl = 'TabLine' },
      text.seprator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        return {
          text.seprator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.seprator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
      end),
      text.spring(),
      win.all_in_tab(tab.get_current()).foreach(function(winid)
        return {
          text.seprator('', 'TabLine', 'TabLineFill'),
          win.is_top(winid) and '' or '',
          win.get_filename.unique(winid),
          text.seprator('', 'TabLine', 'TabLineFill'),
          margin = ' ',
          hl = 'TabLine',
        }
      end),
      text.seprator('', 'TabLine', 'TabLineFill'),
      { '  ', hl = 'TabLine' },
      hl = 'TabLineFill',
    }
  end
  tabline.set(renderer, opt)
end

function preset.active_wins_at_end(opt)
  local renderer = function()
    return {
      { '  ', hl = 'TabLine' },
      text.seprator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        return {
          text.seprator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.seprator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
      end),
      win.all_in_tab(tab.get_current()).foreach(function(winid)
        return {
          text.seprator('', 'TabLine', 'TabLineFill'),
          win.is_top(winid) and '' or '',
          win.get_filename.unique(winid),
          text.seprator('', 'TabLine', 'TabLineFill'),
          margin = ' ',
          hl = 'TabLine',
        }
      end),
      hl = 'TabLineFill',
    }
  end
  tabline.set(renderer, opt)
end

function preset.active_tab_with_wins(opt)
  local renderer = function()
    return {
      hl = 'TabLineFill',
      { '  ', hl = 'TabLine' },
      text.seprator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        local nodes = {
          text.seprator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.seprator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
        if tab.is_active(tabid) then
          nodes[#nodes + 1] = win.all_in_tab(tabid).foreach(function(winid)
            return {
              text.seprator('', 'TabLine', 'TabLineFill'),
              win.is_top(winid) and '' or '',
              win.get_filename.unique(winid),
              text.seprator('', 'TabLine', 'TabLineFill'),
              margin = ' ',
              hl = 'TabLine',
            }
          end)
        end
        return nodes
      end),
    }
  end
  tabline.set(renderer, opt)
end

function preset.tab_with_top_win(opt)
  local renderer = function()
    return {
      hl = 'TabLineFill',
      { '  ', hl = 'TabLine' },
      text.seprator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        local winid = tab.get_current_win(tabid)
        return {
          text.seprator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.seprator('', hl, 'TabLineFill'),
          {
            text.seprator('', 'TabLine', 'TabLineFill'),
            win.is_top(winid) and '' or '',
            win.get_filename.unique(winid),
            text.seprator('', 'TabLine', 'TabLineFill'),
            margin = ' ',
            hl = 'TabLine',
          },
          margin = ' ',
          hl = hl,
        }
      end),
    }
  end
  tabline.set(renderer, opt)
end

function preset.tab_only(opt)
  local renderer = function()
    return {
      hl = 'TabLineFill',
      { '  ', hl = 'TabLine' },
      text.seprator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        return {
          text.seprator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.seprator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
      end),
    }
  end
  tabline.set(renderer, opt)
end

tabline.preset = preset

-- [[
--
-- Deprecated Area
--
-- ]
local util = require('tabby.util')
local component = require('tabby.component')

---@class TabbyTablineOpt
---@field layout TabbyTablineLayout
---@field hl TabbyHighlight background highlight
---@field head? TabbyText[] display at start of tabline
---@field active_tab TabbyTabLabelOpt
---@field inactive_tab TabbyTabLabelOpt
---@field win TabbyWinLabelOpt
---@field active_win? TabbyWinLabelOpt need by "tab_with_top_win", fallback to win if this is nil
---@field top_win? TabbyWinLabelOpt need by "active_tab_with_wins" and "active_wins_at_end", fallback to win if this is nil
---@field tail? TabbyText[] display at end of tabline

---@class TabbyTabLabelOpt
---@field label string|TabbyText|fun(tabid:number):TabbyText
---@field left_sep string|TabbyText
---@field right_sep string|TabbyText

---@alias TabbyTablineLayout
---| "active_wins_at_tail" # windows in active tab will be display at end of tabline
---| "active_wins_at_end" # windows in active tab will be display at end of all tab labels
---| "tab_with_top_win"  # the top window display after each tab.
---| "active_tab_with_wins" # windows label follow active tab
---| "tab_only" # no windows label, only tab

---@class TabbyWinLabelOpt
---@field label string|TabbyText|fun(winid:number):TabbyText
---@field left_sep string|TabbyText
---@field inner_sep string|TabbyText won't works in "tab_with_top_win" layout
---@field right_sep string|TabbyText

---@param tabid number tab id
---@param opt TabbyTabLabelOpt
---@return TabbyComTab
function tabline.render_tab_label(tabid, opt)
  local label = opt.label
  if type(opt.label) == 'function' then
    label = opt.label(tabid)
  end
  return {
    type = 'tab',
    tabid = tabid,
    label = label,
    left_sep = opt.left_sep,
    right_sep = opt.right_sep,
  }
end

---@param winid number window id
---@param is_first boolean
---@param is_last boolean
---@param opt TabbyWinLabelOpt
---@return TabbyComWin
function tabline.render_win_label(winid, is_first, is_last, opt)
  local label = opt.label
  if type(opt.label) == 'function' then
    label = opt.label(winid)
  end
  local left_sep = opt.inner_sep or opt.left_sep
  local right_sep = opt.inner_sep or opt.right_sep
  if is_first then
    left_sep = opt.left_sep
  end
  if is_last then
    right_sep = opt.right_sep
  end
  return {
    type = 'win',
    winid = winid,
    label = label,
    left_sep = left_sep,
    right_sep = right_sep,
  }
end

---@param opt TabbyTablineOpt
---@return string statusline-format text
function tabline.legacy_render(opt)
  ---@type TabbyComponent[]
  local coms = {}
  -- head
  if opt.head then
    for _, head_item in ipairs(opt.head) do
      table.insert(coms, { type = 'text', text = head_item })
    end
  end
  -- tabs and wins
  local tabs = vim.api.nvim_list_tabpages()
  local current_tab = vim.api.nvim_get_current_tabpage()
  for _, tabid in ipairs(tabs) do
    if tabid == current_tab then
      table.insert(coms, tabline.render_tab_label(tabid, opt.active_tab))
      if opt.layout == 'active_tab_with_wins' then
        local wins = util.tabpage_list_wins(current_tab)
        local top_win = vim.api.nvim_tabpage_get_win(current_tab)
        for i, winid in ipairs(wins) do
          local win_opt = opt.win
          if winid == top_win and opt.top_win ~= nil then
            win_opt = opt.top_win
          end
          table.insert(coms, tabline.render_win_label(winid, i == 1, i == #wins, win_opt))
        end
      end
    else
      table.insert(coms, tabline.render_tab_label(tabid, opt.inactive_tab))
    end
    if opt.layout == 'tab_with_top_win' then
      local win_opt = opt.win
      if tabid == current_tab and opt.active_win then
        win_opt = opt.active_win
      end
      local winid = vim.api.nvim_tabpage_get_win(tabid)
      table.insert(coms, tabline.render_win_label(winid, true, true, win_opt))
    end
  end
  if opt.layout == 'active_wins_at_end' or opt.layout == 'active_wins_at_tail' then
    if opt.layout == 'active_wins_at_tail' then
      table.insert(coms, { type = 'text', text = { '%=', hl = opt.hl } })
    end
    local wins = util.tabpage_list_wins(current_tab)
    local top_win = vim.api.nvim_tabpage_get_win(current_tab)
    for i, winid in ipairs(wins) do
      local win_opt = opt.win
      if winid == top_win and opt.top_win ~= nil then
        win_opt = opt.top_win
      end
      table.insert(coms, tabline.render_win_label(winid, i == 1, i == #wins, win_opt))
    end
  end
  -- empty space in line
  table.insert(coms, { type = 'text', text = { '', hl = opt.hl } })
  -- tail
  if opt.tail then
    if opt.layout ~= 'active_wins_at_tail' then
      table.insert(coms, { type = 'text', text = { '%=' } })
    end
    for _, tail_item in ipairs(opt.tail) do
      table.insert(coms, { type = 'text', text = tail_item })
    end
  end

  return table.concat(vim.tbl_map(component.render, coms))
end

return tabline
