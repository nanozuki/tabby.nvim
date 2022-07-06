local plugins = {
  'savq/paq-nvim',
  { 'shaunsingh/nord.nvim' },
  { 'rose-pine/neovim', as = 'rose-pine' },
}

function Bootstrap()
  local paqs_path = vim.fn.stdpath('data') .. '/site/pack/paqs/start/paq-nvim'
  if vim.fn.empty(vim.fn.glob(paqs_path)) > 0 then
    vim.fn.system({
      'git',
      'clone',
      '--depth',
      '1',
      'https://github.com/savq/paq-nvim.git',
      paqs_path,
    })
    vim.cmd([[packadd paq-nvim]])
  end

  vim.cmd('packadd paq-nvim')
  local paq = require('paq')
  vim.cmd('autocmd User PaqDoneInstall quit')
  paq(plugins)
  paq.install()
end

local use_theme = require('use_theme')
local setup = require('setup')

-- put your test config to here or use boilerplate code
use_theme.rose_pine_dawn()
setup.use_preset(require('tabby.presets').active_wins_at_tail)
