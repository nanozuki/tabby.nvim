local tabline = {}

local module = {
  ---@type fun(line:TabbyLine):TabbyNode
  fn = nil,
  ---@type TabbyLineOption?
  opt = nil,
}

local render = require('tabby.module.render')
--local log = require('tabby.module.log')
local lines = require('tabby.feature.lines')

---set tabline render function
---@param fn fun(line:TabbyLine):TabbyNode
---@param opt? TabbyLineOption
function tabline.set(fn, opt)
  module = {
    fn = fn,
    opt = opt,
  }
  if vim.api.nvim_get_vvar('vim_did_enter') then
    tabline.init()
  else
    vim.cmd("au VimEnter * lua require'tabby.tabline'.init()")
  end
end

function tabline.init()
  vim.o.tabline = '%!TabbyRenderTabline()'
  vim.cmd([[command! -nargs=1 TabRename lua require('tabby.feature.tab_name').set(0, <f-args>)]])
end

function tabline.render()
  local line = lines.get_line(module.opt)
  return render.node(module.fn(line))
end

local preset = {}

---@class TabbyTablinePresetOption: TabbyLineOption
---@field style 'upward-triangle'|'downward-triangle'|'airline'|'bubble'|'non-nerdfont' @default 'upward-triangle' @todo
---@field theme TabbyTablinePresetTheme

---@class TabbyTablinePresetTheme
---@field fill TabbyHighlight
---@field head TabbyHighlight
---@field current_tab TabbyHighlight
---@field tab TabbyHighlight
---@field win TabbyHighlight
---@field tail TabbyHighlight

---@type TabbyTablinePresetOption
local default_preset_option = {
  style = 'upward-triangle', -- TODO
  theme = {
    fill = 'TabLineFill',
    head = 'TabLine',
    current_tab = 'TabLineSel',
    tab = 'TabLine',
    win = 'TabLine',
    tail = 'TabLine',
  },
}

---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_head(line, opt)
  return {
    { '  ', hl = opt.theme.head },
    line.sep('', opt.theme.head, opt.theme.fill),
  }
end

---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_tail(line, opt)
  return {
    line.sep('', opt.theme.tail, opt.theme.fill),
    { '  ', hl = opt.theme.tail },
  }
end

---@param line TabbyLine
---@param tab TabbyTab
---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_tab(line, tab, opt)
  local hl = tab.is_current() and opt.theme.current_tab or opt.theme.tab
  return {
    line.sep('', hl, opt.theme.fill),
    tab.is_current() and '' or '',
    tab.number(),
    tab.name(),
    tab.close_btn(''),
    line.sep('', hl, opt.theme.fill),
    hl = hl,
    margin = ' ',
  }
end

---@param line TabbyLine
---@param win TabbyWin
---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_win(line, win, opt)
  return {
    line.sep('', opt.theme.win, opt.theme.fill),
    win.is_current() and '' or '',
    win.buf_name(),
    line.sep('', opt.theme.win, opt.theme.fill),
    hl = opt.theme.win,
    margin = ' ',
  }
end

function preset.active_wins_at_tail(opt)
  local o = vim.tbl_deep_extend('force', default_preset_option, opt or {})
  tabline.set(function(line)
    return {
      preset_head(line, o),
      line.tabs().foreach(function(tab)
        return preset_tab(line, tab, o)
      end),
      line.spacer(),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return preset_win(line, win, o)
      end),
      preset_tail(line, o),
      hl = o.theme.fill,
    }
  end, o)
end

function preset.active_wins_at_end(opt)
  local o = vim.tbl_deep_extend('force', default_preset_option, opt or {})
  tabline.set(function(line)
    return {
      preset_head(line, o),
      line.tabs().foreach(function(tab)
        return preset_tab(line, tab, o)
      end),
      line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
        return preset_win(line, win, o)
      end),
      hl = o.theme.fill,
    }
  end, o)
end

function preset.active_tab_with_wins(opt)
  local o = vim.tbl_deep_extend('force', default_preset_option, opt or {})
  tabline.set(function(line)
    return {
      preset_head(line, o),
      line.tabs().foreach(function(tab)
        local tab_node = preset_tab(line, tab, o)
        if tab.is_current() == false then
          return tab_node
        end
        local wins_node = line.wins_in_tab(tab.id).foreach(function(win)
          return preset_win(line, win, o)
        end)
        return { tab_node, wins_node }
      end),
      hl = o.theme.fill,
    }
  end, o)
end

function preset.tab_with_top_win(opt)
  ---@type TabbyLineOption
  local line_opt = {
    tab_name = {
      test = 'a',
      name_fallback = function(_)
        return ''
      end,
    },
  }
  local o = vim.tbl_deep_extend('force', default_preset_option, line_opt, opt or {})
  tabline.set(function(line)
    return {
      preset_head(line, o),
      line.tabs().foreach(function(tab)
        return {
          preset_tab(line, tab, o),
          preset_win(line, tab.current_win(), o),
        }
      end),
      hl = o.theme.fill,
    }
  end, o)
end

function preset.tab_only(opt)
  local o = vim.tbl_deep_extend('force', default_preset_option, opt or {})
  tabline.set(function(line)
    return {
      preset_head(line, o),
      line.tabs().foreach(function(tab)
        return preset_tab(line, tab, o)
      end),
      hl = o.theme.fill,
    }
  end, o)
end

---Use tabline preset config
---@param name 'active_wins_at_tail'|'active_wins_at_end'|'tab_with_top_win'|'active_tab_with_wins'|'tab_only'
---@param opt? TabbyTablinePresetOption
function tabline.use_preset(name, opt)
  if name == 'active_wins_at_tail' then
    preset.active_wins_at_tail(opt)
  elseif name == 'active_wins_at_end' then
    preset.active_wins_at_end(opt)
  elseif name == 'tab_with_top_win' then
    preset.tab_with_top_win(opt)
  elseif name == 'active_tab_with_wins' then
    preset.active_tab_with_wins(opt)
  elseif name == 'tab_only' then
    preset.tab_only(opt)
  else
    vim.notify('unknown preset')
  end
end

return tabline
