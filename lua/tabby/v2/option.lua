local tabby = {}

local option = {
  layout = 'active_wins_at_tail',
  hl = 'TabLineFill',
  head = {
    { '  ', hl = tabby.hl:from('TabLine') },
    { '', hl = tabby.hl:from('TabLine'):sep('TabLineFill') },
  },
  tab = {
    hl = tabby.hl:from('TabLine'),
    sep = { left = '', right = '' },
    label = { '', tabby.tab.number, tabby.tab.name, tabby.tab.close_btn('x') },
    join = ' ',

    active = {
      hl = tabby.hl:from('TabLineSel'),
      label = { '', tabby.tab.number, tabby.tab.name, tabby.tab.close_btn('x') },
    },
  },
  win = {
    hl = tabby.hl:from('TabLine'),
    label = { '', tabby.win.name('unique') },
    sep = { left = '', right = '' },
    join = ' ',

    top = {
      label = { '', tabby.win.name('unique') },
    },
  },
  tail = {
    { '', hl = tabby.hl:from('TabLine'):sep('TabLineFill') },
    { '  ', hl = tabby.hl:from('TabLine') },
  },
  ['tab.name'] = {
    default = function(tabid)
      tabby.win.unique_name(tabby.tab.focus_win(tabid))
    end,
  },
}

return option
