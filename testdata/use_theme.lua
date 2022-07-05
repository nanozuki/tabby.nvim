local use_theme = {}

function use_theme.nord()
  vim.opt.background = 'dark'
  vim.g.nord_borders = true
  require('nord').set()
  vim.cmd('colorscheme nord')
end

function use_theme.rose_pine_dawn()
  vim.o.background = 'light'
  vim.cmd('colorscheme rose-pine')
end

return use_theme
