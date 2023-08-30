-- set repreduce/testing environment
-- inspired by https://github.com/folke/lazy.nvim/wiki/Minimal-%60init.lua%60-to-Reproduce-an-Issue
-- set stdpath, use ./testenv
local root = vim.fn.fnamemodify('./testenv', ':p')
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
  { 'shaunsingh/nord.nvim' },
  { 'ellisonleao/gruvbox.nvim' },
  { 'AlexvZyl/nordic.nvim' },
  { 'folke/tokyonight.nvim' },
  { 'nvim-lualine/lualine.nvim' },
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

-- put your test config to here
require('tabby.tabline').use_preset('active_wins_at_tail', {
  -- lualine_theme = 'rose-pine',
})
