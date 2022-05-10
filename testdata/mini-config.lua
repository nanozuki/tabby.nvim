-- packer
local fn = vim.fn
local packer_bootstrap
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({
    'git',
    'clone',
    '--depth',
    '1',
    'https://github.com/wbthomason/packer.nvim',
    install_path,
  })
  vim.cmd([[packadd packer.nvim]])
end

require('packer').startup(function(use)
  use('wbthomason/packer.nvim')
  use({
    'rose-pine/neovim',
    as = 'rose-pine',
    config = function()
      vim.o.background = 'light'
      vim.cmd('colorscheme rose-pine')
      require('tabby').setup({
        -- put your test config to here:
        tabline = require('tabby.presets').active_wins_at_tail,
      })
    end,
  })
  if packer_bootstrap then
    require('packer').sync()
  end
end)
