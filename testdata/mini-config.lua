vim.opt.mouse = 'ar'
vim.opt.showtabline = 2
-- put your test config to here or use boilerplate code
require('use_theme').nord()
-- require('setup').use_preset(require('tabby.presets').active_wins_at_tail)
require('tabby.tabline').preset.active_wins_at_tail()
