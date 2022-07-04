---@class TablineModule
---@field renderer? fun():TabbyNode
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
---@param fn fun():TabbyNode
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
      text.separator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        return {
          text.separator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.separator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
      end),
      text.spring(),
      win.all_in_tab(tab.get_current()).foreach(function(winid)
        return {
          text.separator('', 'TabLine', 'TabLineFill'),
          win.is_top(winid) and '' or '',
          win.get_filename.unique(winid),
          text.separator('', 'TabLine', 'TabLineFill'),
          margin = ' ',
          hl = 'TabLine',
        }
      end),
      text.separator('', 'TabLine', 'TabLineFill'),
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
      text.separator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        return {
          text.separator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.separator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
      end),
      win.all_in_tab(tab.get_current()).foreach(function(winid)
        return {
          text.separator('', 'TabLine', 'TabLineFill'),
          win.is_top(winid) and '' or '',
          win.get_filename.unique(winid),
          text.separator('', 'TabLine', 'TabLineFill'),
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
      text.separator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        local nodes = {
          text.separator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.separator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
        if tab.is_active(tabid) then
          nodes[#nodes + 1] = win.all_in_tab(tabid).foreach(function(winid)
            return {
              text.separator('', 'TabLine', 'TabLineFill'),
              win.is_top(winid) and '' or '',
              win.get_filename.unique(winid),
              text.separator('', 'TabLine', 'TabLineFill'),
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
      text.separator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        local winid = tab.get_current_win(tabid)
        return {
          text.separator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.separator('', hl, 'TabLineFill'),
          {
            text.separator('', 'TabLine', 'TabLineFill'),
            win.is_top(winid) and '' or '',
            win.get_filename.unique(winid),
            text.separator('', 'TabLine', 'TabLineFill'),
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
      text.separator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(function(tabid)
        local hl = tab.is_active(tabid) and 'TabLineSel' or 'TabLine'
        return {
          text.separator('', hl, 'TabLineFill'),
          tab.is_active(tabid) and '' or '',
          tab.get_number(tabid),
          tab.get_name(tabid),
          tab.close_btn(tabid, 'x', { hl = 'Error' }),
          text.separator('', hl, 'TabLineFill'),
          margin = ' ',
          hl = hl,
        }
      end),
    }
  end
  tabline.set(renderer, opt)
end

tabline.preset = preset

return tabline
