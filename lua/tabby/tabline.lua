local tabline = {
  renderer = nil,
  opt = {
    show_at_least = 1,
  },
}

local text = require('tabby.text')
local tab = require('tabby.tab')
local win = require('tabby.win')
--local log = require('tabby.module.log')

---@class TablineOpt
---@field show_at_least number show tabline when there are at least n tabs.

---set tabline render function
---@param fn fun():TabbyNode
---@param opt? TablineOpt
function tabline.set(fn, opt)
  tabline.renderer = fn
  if opt ~= nil then
    tabline.opt = vim.tbl_extend('force', tabline.opt, opt)
  end
  vim.cmd([[
    augroup tabby_show_control
      autocmd!
      autocmd TabNew,TabClosed * lua require("tabby.tabline").show_control()
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
  vim.cmd([[command! -nargs=1 TabRename lua require('tabby.tab').set_current_name(<f-args>)]])
end

function tabline.render()
  require('tabby.module.filename').flush_unique_name_cache()
  return require('tabby.module.render').node(tabline.renderer())
end

function tabline.show_control()
  local tabs = vim.api.nvim_list_tabpages()
  if #tabs >= tabline.opt.show_at_least then
    vim.o.showtabline = 2
  else
    vim.o.showtabline = 0
  end
end

local preset = {}

local function header()
  return {
    { '  ', hl = 'TabLine' },
    text.separator('', 'TabLine', 'TabLineFill'),
  }
end

local function tab_label(tabid)
  local hl = tab.is_current(tabid) and 'TabLineSel' or 'TabLine'
  return {
    text.separator('', hl, 'TabLineFill'),
    tab.is_current(tabid) and '' or '',
    tab.get_number(tabid),
    tab.get_name(tabid),
    tab.close_btn(tabid, ''),
    text.separator('', hl, 'TabLineFill'),
    margin = ' ',
    hl = hl,
  }
end

local function win_label(winid)
  return {
    text.separator('', 'TabLine', 'TabLineFill'),
    win.is_current(winid) and '' or '',
    win.get_bufname(winid),
    text.separator('', 'TabLine', 'TabLineFill'),
    margin = ' ',
    hl = 'TabLine',
  }
end

function preset.active_wins_at_tail(opt)
  local renderer = function()
    local node = {
      { '  ', hl = 'TabLine' },
      text.separator('', 'TabLine', 'TabLineFill'),
      tab.all().foreach(tab_label),
      text.spring(),
      win.all_in_tab(tab.get_current_tab()).foreach(win_label),
      text.separator('', 'TabLine', 'TabLineFill'),
      { '  ', hl = 'TabLine' },

      hl = 'TabLineFill',
    }
    return node
  end
  tabline.set(renderer, opt)
end

function preset.active_wins_at_end(opt)
  local renderer = function()
    return {
      header(),
      tab.all().foreach(tab_label),
      win.all_in_tab(tab.get_current_tab()).foreach(win_label),
      hl = 'TabLineFill',
    }
  end
  tabline.set(renderer, opt)
end

function preset.active_tab_with_wins(opt)
  local renderer = function()
    return {
      header(),
      tab.all().foreach(function(tabid)
        local nodes = tab_label(tabid)
        if tab.is_active(tabid) then
          nodes[#nodes + 1] = win.all_in_tab(tabid).foreach(win_label)
        end
        return nodes
      end),
      hl = 'TabLineFill',
    }
  end
  tabline.set(renderer, opt)
end

function preset.tab_with_top_win(opt)
  -- TODO: move right place
  tab.set_option({
    name_fallback = function()
      return ''
    end,
  })
  local renderer = function()
    return {
      header(),
      tab.all().foreach(function(tabid)
        return {
          tab_label(tabid),
          win_label(tab.get_current_win(tabid)),
        }
      end),
      hl = 'TabLineFill',
    }
  end
  tabline.set(renderer, opt)
end

function preset.tab_only(opt)
  local renderer = function()
    return {
      hl = 'TabLineFill',
      header(),
      tab.all().foreach(tab_label),
    }
  end
  tabline.set(renderer, opt)
end

tabline.preset = preset

return tabline
