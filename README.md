# tabby.nvim

A declarative, highly configurable, and neovim style tabline. Use your nvim tabs as a workspace multiplexer!

![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/banner.png)

## Concept

### A line for the vim tab page, not for buffers

A tab page in vim holds one or more windows(not buffers).
You can easily switch between tab pages to have several collections of windows to work on different things.

Tabline can help you use multiple tabs. Meanwhile, the bufferline is simply an array of opened files. As a result,
Bufferline limits the power of vim, especially when editing a large workspace with many opened files.

For example, you are writing a backend service:

```
Tab1: nvim-tree, controller/user.go, entity/user.go
Tab2: nvim-tree, pkg/cache.go, redis/client.go
Tab3: Terminal
Tab4: Neogit.nvim
```

### Declarative, highly configurable

Tabby provides a declarative way to configure tabline.
You can set the tabline to whatever neovim natively supports and complete the config with any lua code.
At least that's the goal of tabby. And also, the tabby provides some presets to quick start or as your example.

## Install

Use your plugin manager to installing 'nanozuki/tabby.com':

- packer.nvim

```lua
  use 'nanozuki/tabby.nvim',
```

- vim-plug

```viml
  Plug 'nanozuki/tabby.nvim'
```

## Setup

At default, neovim only display tabline when there are at least two tab pages. If you want always display tabline:

```lua
vim.o.showtabline = 2
```

And you can setup your own tabline like this:

```lua
local theme = {
  fill = 'TabLineFill',
  -- Also you can do this: fill = { fg='#f2e9de', bg='#907aa9', style='italic' }
  head = 'TabLine',
  current_tab = 'TabLineSel',
  tab = 'TabLine',
  win = 'TabLine',
  tail = 'TabLine',
}
tabline.set(function(line)
  return {
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
    },
    line.tabs().foreach(function(tab)
      local hl = tab.is_current() and theme.current_tab or theme.tab
      return {
        line.sep('', hl, theme.fill),
        tab.is_current() and '' or '',
        tab.number(),
        tab.name(),
        tab.close_btn(''),
        line.sep('', hl, theme.fill),
        hl = hl,
        margin = ' ',
      }
    end),
    line.spacer(),
    line.wins_in_tab(line.api.get_current_tab()).foreach(function(win)
      return {
        line.sep('', theme.win, theme.fill),
        win.is_current() and '' or '',
        win.buf_name(),
        line.sep('', theme.win, theme.fill),
        hl = theme.win,
        margin = ' ',
      }
    end),
    {
      line.sep('', theme.tail, theme.fill),
      { '  ', hl = theme.tail },
    },
    hl = theme.fill,
  }
end)
```

**For configuration details, please check [Customize](#Customize).**

**Want to quick start? That's fine, you can just use [Preset Configs](#Use-Preset)**

## Customize

Customize tabby with `require('tabby.tabline').set(fn, opt)`:

```lua
require('tabby.tabline').set(fn, opt)
```

```
tabline.set({fn}, {opt?})                                          *tabline.set*
    set tabline render function

    Parameters: ~
        {fn}    fun(line:TabbyLine):TabbyNode       render function for tabline
        {opt?}  TabbyLineOption                     option for this line
```

All you need is to provide a render function, that use the variable `line`([TabbyLine](#TabbyLine))
to complete tabline node ([TabbyNode](#TabbyNode)). The `line` variable gathered all features the tabby provided.
And you can use `opt` ([TabbyLineOption](#TabbyLineOption)) to customize some behaviors.

### TabbyLine

The `line` variable gathered all features the tabby provided.

```
line.tabs().tabs
    Return all Tab

    Return:
        Array of tabs

line.tabs().foreach({renderer})
    Use the renderer to render every Tab.

    Parameters:
        {renderer}    a function, receive a Tab and return Node

line.wins().wins

line.wins().foreach({renderer})
```

- line.tabs()

  Return all tabs

  Return:
  Tab array

Fields:

- tabs `fun():TabbyTabs`

  return all tabs

- wins `fun():TabbyWins`

  return all wins

- wins_in_tab `fun(tabid:number):TabbyWins`

  return all wins in that tab

- sep `fun(symbol:string,cur_hl:TabbyHighlight, back_hl:TabbyHighlight):TabbyNode`

  make a separator

- spacer `fun():TabbyNode`

  Separation point between alignment sections. Each section will be separated by an equal number of spaces.

- api `TabbyAPI`

  neovim apis wrapper

### TabbyTabs

Fields:

- tabs `TabbyTab[]`

  array of tabs

- foreach `fun(fn:fun(tab:TabbyTab)):TabbyNode`

  render tabs by given render function

### TabbyWins

Fields:

- wins `TabbyWin[]`

  windows

- foreach `fun(fn:fun(win:TabbyWin)):TabbyNode`

  render wins by given render function

### TabbyTab

Fields:

- id `number`

  tabid

- current_win `fun():TabbyWin`

  current window in this tab

- wins `fun():TabbyWins`

  windows in this tab

- number `fun():number`

  return tab number

- is_current `fun():boolean`

  return if this tab is current tab

- name `fun():string`

  return tab name

- close_btn `fun(symbol:string):TabbyNode`

  return close btn

### TabbyWin

Fields:

- id `number`

  winid

- tab `fun():TabbyTab`

  return tab this window belonged

- is_current `fun():boolean`

  return if this window is current window

- file_icon `fun():string?`

  file icon, require devicons

- buf_name `fun():string`

  file name

### TabbyNode

Fields:

### TabbyHighlight

Fields:

### TabbyLayout

Fields:

### TabbyLineOption

```lua
{
    tab_name = {
        name_fallback = 'fun(tabid:number):string',
    },
    buf_name = {
        mode = "'unique'|'relative'|'tail'|'shorten'",
    }
}
```

## Lagacy

### options

```lua
---@class TabbyOption
---@field show_at_least number show tabline when there are at least n tabs.
```

- show_at_least

Only show tabline when there are at least n tabs.

### Base object for text

The basic config unit in tabby is `TabbyText`. It's a set of text content,
highlight group and layout setting. You may use it in many places. The type
definition is:

```lua
---@class TabbyText
---@field [1] string|fun():string text content or a function to return context
---@field hl  nil|string|TabbyHighlight
---@field lo  nil|TabbyLayout

---@class TabbyHighlight
---@field fg    string hex color for foreground
---@field bg    string hex color for background
---@field style string Highlight gui style
---@field name  string highlight group name

---@class TabbyLayout
---@field max_width number
---@field min_width number
---@field justify   "left"|"right" default is left
```

For example:

```lua
local text1 = { "Tab 1" }
local text2 = {
    "Tab 2",
    hl = "TablineSel",
}
local text3 = {
    "Tab 3",
    hl = { fg = my_hl.fg, bg = my_hl.bg, style = "bold" },
    lo = { min_width = 20, justify = "right" },
}
local cwd = {
    function()
	return " " .. vim.fn.fnamemodify(vim.fn.getcwd(), ":t") .. " "
    end
    hl = "TablineSel",
}
```

There is a util for extract values from highlight:

```lua
local hl_normal = util.extract_nvim_hl("Normal")
local labal = {
	"  " .. tabid .. " ",
	hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = "bold" },
}
```

### Customize with high level apis

Through setting the `TabbyOption.tabline` to use the high-level api to customize
tabby. You can edit one of the three built-in layouts. (Corresponding to the
three preset values)

```lua
---@class TabbyTablineOpt
---@field layout TabbyTablineLayout
---@field hl TabbyHighlight background highlight
---@field head? TabbyText[] display at start of tabline
---@field active_tab TabbyTabLabelOpt
---@field inactive_tab TabbyTabLabelOpt
---@field win TabbyWinLabelOpt
---@field active_win? WinLabelOpt need by "tab_with_top_win", fallback to win if this is nil
---@field top_win? TabbyWinLabelOpt need by "active_tab_with_wins" and "active_wins_at_end", fallback to win if this is nil
---@field tail? TabbyText[] display at end of tabline

---@alias TabbyTablineLayout
---| "active_tab_with_wins" # windows label follow active tab
---| "active_wins_at_end" # windows in active tab will be display at end of all tab labels
---| "tab_with_top_win"  # the top window display after each tab.

---@class TabbyTabLabelOpt
---@field label string|TabbyText|fun(tabid:number):TabbyText
---@field left_sep string|TabbyText
---@field right_sep string|TabbyText

---@class TabbyWinLabelOpt
---@field label string|TabbyText|fun(winid:number):TabbyText
---@field left_sep string|TabbyText
---@field inner_sep string|TabbyText won't works in "tab_with_top_win" layout
---@field right_sep string|TabbyText
```

You can find three [presets](./lua/tabby/presets.lua) config for example.

### Customize with low level apis

If built-in layouts do not satisfy you, you can also use the low-level API to
define the tabline from scratch by setting `TabbyOption.components`.

`TabbyOption.components` is a function which return an array of
`TabbyComponent`. The `TabbyComponent` is object like:

```lua
{
    "type": "<component type>",
    -- "... config ..."
}
```

These are all TabbyComponents:

- TabbyComTab

TabbyComTab can receive a tabid to render a tab label.

```lua
---@class TabbyComTab
---@field type "tab"
---@field tabid number
---@field label string|TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText
```

- TabbyComWin

TabbyComWin can receive a winid to render a window label.

```lua
---@class TabbyComWin
---@field type "win"
---@field winid number
---@field label TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText
```

- TabbyComText

TabbyComText for rendering static text.

```lua
---@class TabbyComText
---@field type "text"
---@field text TabbyText
```

- TabbyComSpring

TabbyComSpring mark a separation point. Each separation point will be print as
equal number of spaces.

```lua
---@class TabbyComSpring
---@field type "spring"
```

**Example**

For example, we can use low-level api to define the presets
`active_wins_at_end`:

[active_wins_at_end](./examples/low-level-example.lua)

## Setup

### Use presets

You can use presets for a quick start. The preset config uses nerdfont,
and you should use a nerdfont-patched font to display that correctly.

Built-in presets only use the highlight group `Tabline`, `TablineSel`,
`TablineFill` and `Normal`, to support most colorschemes. To use presets:

```lua
require('tabby.tabline').presets.tab_with_top_win(opt)
```

There are five
[presets](https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua)
for now:

- active_wins_at_tail [default]

![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/active_wins_at_tail.png)

Put all windows' labels in active tabpage at end of whold tabline.

- active_wins_at_end

Put all windows' labels in active tabpage after all tags label. In-active
tabpage's window won't display.

![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/tabby-default-1.png)

- tab_with_top_win

Each tab lab with a top window label followed. The `top window` is the focus
window when you enter a tabpage.

![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/tab_with_top_win.png)

- active_tab_with_wins

Active tabpage's windows' labels is displayed after the active tabpage's label.

![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/active_tab_with_wins.png)

- tab_only

No windows label, only tab. and use focus window to name tab

![](https://user-images.githubusercontent.com/4208028/136306954-815d01df-bcf1-4e88-8621-8fb7aca4eac3.png)

### Examples and Gallary

These are some awesome exmaples shared by tabby.nvim users! Also welcome to share your own!

[Discussions: show and tell](https://github.com/nanozuki/tabby.nvim/discussions/categories/show-and-tell)

### Key mapping example

Tabby uses native nvim tab, so you can directly use nvim tab operation. Maybe you want to map some operation. For example:

```lua
vim.api.nvim_set_keymap("n", "<leader>ta", ":$tabnew<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tc", ":tabclose<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>to", ":tabonly<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tn", ":tabn<CR>", { noremap = true })
vim.api.nvim_set_keymap("n", "<leader>tp", ":tabp<CR>", { noremap = true })
-- move current tab to previous position
vim.api.nvim_set_keymap("n", "<leader>tmp", ":-tabmove<CR>", { noremap = true })
-- move current tab to next position
vim.api.nvim_set_keymap("n", "<leader>tmn", ":+tabmove<CR>", { noremap = true })
```

And in fact, vim has some built-in keymapping, it's better to read `:help tabline`. Here are some useful mappings:

```
gt					*i_CTRL-<PageDown>* *i_<C-PageDown>*
		Go to the next tab page.  Wraps around from the last to the
		first one.
{count}gt	Go to tab page {count}.  The first tab page has number one.
g<Tab>		Go to previous (last accessed) tab page.
gT		Go to the previous tab page.  Wraps around from the first one
		to the last one.
```

The `{count}` is the number displyed in presets.

## TODO

- [x] Rename tab
- [x] Unique short name for window label
- [ ] Button for close tab and add tab
- [ ] Custom click handler
- [ ] Telescope support
- [ ] Nvim doc
- [ ] Utils library
