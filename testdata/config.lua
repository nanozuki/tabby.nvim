vim.opt.mouse = 'ar'
vim.opt.showtabline = 2

-- plugin manager
local lazypath = vim.fn.stdpath('data') .. '/lazy/lazy.nvim'
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    'git',
    'clone',
    '--filter=blob:none',
    'https://github.com/folke/lazy.nvim.git',
    '--branch=stable', -- latest stable release
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- themes
local theme = 'rose-pine'
require('lazy').setup({
  {
    'rose-pine/neovim',
    name = 'rose-pine',
    enabled = theme == 'rose-pine',
    config = function()
      vim.o.background = 'light'
      vim.cmd('colorscheme rose-pine')
    end,
  },
  {
    'shaunsingh/nord.nvim',
    enabled = theme == 'nord',
    config = function()
      vim.o.background = 'dark'
      vim.cmd('colorscheme nord')
    end,
  },
})

-- put your test config to here or use boilerplate code
require('tabby.tabline').use_preset('active_wins_at_tail')
