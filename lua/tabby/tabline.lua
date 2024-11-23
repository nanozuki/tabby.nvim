local builder = require('tabby.module.builder')
local lines = require('tabby.feature.lines')
local tab_name = require('tabby.feature.tab_name')
local win_picker = require('tabby.feature.win_picker')
local tab_jumper = require('tabby.feature.tab_jumper')

local tabline = {}

tabline.cfg = {
  ---@type fun(line:TabbyLine):TabbyElement
  fn = nil,
  ---@type TabbyLineOption?
  opt = nil,
}

---set tabline render function
---@param fn fun(line:TabbyLine):TabbyElement
---@param opt? TabbyLineOption
function tabline.set(fn, opt)
  tabline.cfg = {
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
  vim.cmd([[command! -nargs=1 TabRename lua require('tabby.feature.tab_name').set(0,<f-args>)]])
  vim.api.nvim_create_user_command('Tabby', function(opts)
    if opts.fargs[1] == 'rename_tab' then
      tab_name.set(0, opts.fargs[2] or '')
    elseif opts.fargs[1] == 'pick_window' then
      win_picker.select()
    elseif opts.fargs[1] == 'jump_to_tab' then
      tab_jumper.start()
    end
  end, {
    nargs = '+',
    complete = function(_, _, _)
      return { 'rename_tab', 'pick_window', 'jump_to_tab' }
    end,
  })
end

function tabline.render()
  tab_name.pre_render()
  local line = lines.get_line(tabline.cfg.opt)
  tab_jumper.pre_render(line)
  local element = tabline.cfg.fn(line)
  if element.hl == nil or element.hl == '' then
    element.hl = 'TabLineFill'
  end
  local b = builder:new()
  b:render_element(element, {})
  return b:build()
end

local preset = {}

---@class TabbyTablinePresetOption: TabbyLineOption
---@field theme? TabbyTablinePresetTheme
---@field nerdfont? boolean whether use nerdfont @default true
---@field lualine_theme? string lualine theme name @default ''

---@class TabbyTablinePresetTheme
---@field fill TabbyHighlight
---@field head TabbyHighlight
---@field current_tab TabbyHighlight
---@field tab TabbyHighlight
---@field win TabbyHighlight
---@field tail TabbyHighlight

---@type TabbyTablinePresetOption
local default_preset_option = {
  theme = {
    fill = 'TabLineFill',
    head = 'TabLine',
    current_tab = 'TabLineSel',
    tab = 'TabLine',
    win = 'TabLine',
    tail = 'TabLine',
  },
  nerdfont = true,
  lualine_theme = '',
}

---@param opt TabbyTablinePresetOption
---@return string
local function left_sep(opt)
  return opt.nerdfont and '' or '▐'
end

---@param opt TabbyTablinePresetOption
---@return string
local function right_sep(opt)
  return opt.nerdfont and '' or '▌'
end

---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_head(line, opt)
  return {
    { opt.nerdfont and '  ' or ' tabs: ', hl = opt.theme.head },
    line.sep(right_sep(opt), opt.theme.head, opt.theme.fill),
  }
end

---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_tail(line, opt)
  return {
    line.sep(left_sep(opt), opt.theme.tail, opt.theme.fill),
    { opt.nerdfont and '  ' or ' ', hl = opt.theme.tail },
  }
end

---@param line TabbyLine
---@param tab TabbyTab
---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_tab(line, tab, opt)
  local hl = tab.is_current() and opt.theme.current_tab or opt.theme.tab
  local status_icon = opt.nerdfont and { '', '󰆣' } or { '+', '' }
  return {
    line.sep(left_sep(opt), hl, opt.theme.fill),
    tab.in_jump_mode() and tab.jump_key() or {
      tab.is_current() and status_icon[1] or status_icon[2],
      tab.number(),
      margin = ' ',
    },
    tab.name(),
    tab.close_btn(opt.nerdfont and '' or '(x)'),
    line.sep(right_sep(opt), hl, opt.theme.fill),
    hl = hl,
    margin = ' ',
  }
end

---@param line TabbyLine
---@param win TabbyWin
---@param opt TabbyTablinePresetOption
---@return TabbyNode
local function preset_win(line, win, opt)
  local status_icon = opt.nerdfont and { '', '' } or { '*', '' }
  return {
    line.sep(left_sep(opt), opt.theme.win, opt.theme.fill),
    win.is_current() and status_icon[1] or status_icon[2],
    win.buf_name(),
    line.sep(right_sep(opt), opt.theme.win, opt.theme.fill),
    hl = opt.theme.win,
    margin = ' ',
  }
end

local function pre_process_opt(opt)
  if opt and opt.theme == nil and opt.lualine_theme ~= nil then
    local ok, ll_theme = pcall(require, string.format('lualine.themes.%s', opt.lualine_theme))
    if ok then
      opt.theme = {
        fill = ll_theme.normal.c,
        head = ll_theme.visual.a,
        current_tab = ll_theme.normal.a,
        tab = ll_theme.normal.b,
        win = ll_theme.normal.b,
        tail = ll_theme.normal.b,
      }
    end
  end
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
        local wins_node = tab.wins().foreach(function(win)
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
  pre_process_opt(opt)
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
