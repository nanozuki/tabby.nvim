-- set reproduce/testing/playground environment
-- inspired by https://github.com/folke/lazy.nvim/wiki/Minimal-%60init.lua%60-to-Reproduce-an-Issue
local root = vim.fn.fnamemodify('./playground', ':p')
for _, name in ipairs({ 'config', 'data', 'state', 'cache' }) do
  vim.env[('XDG_%s_HOME'):format(name:upper())] = root .. '/' .. name
end
-- bootstrap lazy
local lazypath = root .. '/plugins/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    '--single-branch',
    'https://github.com/folke/lazy.nvim.git',
    lazypath,
  })
end
vim.opt.runtimepath:prepend(lazypath)

-- install theme and other plugins you need
local plugins = {
  { 'rose-pine/neovim', name = 'rose-pine' },
  -- { 'shaunsingh/nord.nvim' },
  -- { 'ellisonleao/gruvbox.nvim' },
  -- { 'AlexvZyl/nordic.nvim' },
  -- { 'folke/tokyonight.nvim' },
  -- { 'nvim-lualine/lualine.nvim' },
}
require('lazy').setup(plugins, {
  root = root .. '/plugins',
})

-- basic config
vim.opt.mouse = 'ar'
vim.opt.showtabline = 2
-- set theme
vim.opt.background = 'light'
vim.cmd.colorscheme('rose-pine')

-- put your test config to here, use tabby in repository directly
-- 1. use customer configs:
-- local theme = {
--   fill = 'TabLineFill',
--   -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
--   head = 'TabLine',
--   current_tab = 'TabLineSel',
--   tab = 'TabLine',
--   win = 'TabLine',
--   tail = 'TabLine',
-- }
-- require('tabby').setup({
--   line = function(line)
--     return {
--       {
--         { '  ', hl = theme.head },
--         line.sep('', theme.head, theme.fill),
--       },
--       line.tabs().foreach(function(tab)
--         local hl = tab.is_current() and theme.current_tab or theme.tab
--         return {
--           line.sep('', hl, theme.fill),
--           tab.is_current() and '' or '󰆣',
--           tab.number(),
--           tab.name(),
--           tab.close_btn(''),
--           line.sep('', hl, theme.fill),
--           hl = hl,
--           margin = ' ',
--         }
--       end),
--       line.spacer(),
--       line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
--         return {
--           line.sep('', theme.win, theme.fill),
--           win.is_current() and '' or '',
--           win.buf_name(),
--           line.sep('', theme.win, theme.fill),
--           hl = theme.win,
--           margin = ' ',
--         }
--       end),
--       {
--         line.sep('', theme.tail, theme.fill),
--         { '  ', hl = theme.tail },
--       },
--       hl = theme.fill,
--     }
--   end,
-- })
-- 2. use preset:
require('tabby').setup({
  preset = 'active_wins_at_tail',
  option = {
    lualine_theme = 'rose-pine',
  },
})
