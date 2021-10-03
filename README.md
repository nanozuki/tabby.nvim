# tabby.nvim

A minimal, configurable, neovim style tabline. Use your nvim tabs as workspace multiplexer!

![](./assets/tabby-default-1.png)
![](./assets/tabby-default-2.png)
![](./assets/tabby-default-3.png)

## Feature

### tabby.nvim is not buffers' list

Tabby.nvim focuses on a vim-style tab instead of buffers list, so tabby only displays the buffers in tabline(although you can use low-level API to write a bufferline). On the other hand, If you use some plugin such as "fzf" or "telescope," you will find the bufferline unnecessary. In that case, you may want to use the tab as its original feature: be a windows layout multiplexer. That might be the reason why you choose tabby.nvim.

### highly configurable and easy to start

With tabby.nvim, you can config your own tabline from scratch. And won't worry the complexy, you can start from presets and example.
As tabby.nvim have complete type annotations (powered by EmmyLua), so you can write config with the help of lua-language-server.

## Quick start

Use your plugin manager to installing:

```
"kyazdani42/nvim-web-devicons",
"nanozuki/tabby.nvim",
```

The `nvim-web-devicons` provide the icon support, you may like to use a nerdfonts-patched font.
If your config dont use icons, you have no need to install that.

And setup tabby in your config file:

```lua
require"tabby".setup()
```

If you use packer:

```lua
use {
    "nanozuki/tabby.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("tabby").setup() end,
}
```

## Use presets

Built-in presets only use the highlight group `Tabline`, `TablineSel`, `TablineFill` and `Normal`,
in case to support most colorschemes.
there are three [presets](https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua) for now:

* active_wins_at_end [default]

Put all windows' labels in active tabpage after all tags label. In-active tabpage's window won't display.

![](./assets/tabby-default-1.png)

* tab_with_top_win

Each tab lab with a top window label followed. The `top window` is the focus window when you enter a tabpage.

![](./assets/tab_with_top_win.png)

* active_tab_with_wins

Active tabpage's windows' labels is displayed after the active tabpage's label.

![](./assets/active_tab_with_wins.png)

```lua
require("tabby").setup({
    tabline = require("tabby.presets").tab_with_top_win,
})
```

## Customize

Customize tabby with `tabby.setup(opt)`, the opt definiation is:

```lua
---@class TabbyOption
---@field tabline? TabbyTablineOpt           high-level api
---@field components? fun():TabbyComponent[] low-level api
```

### Base object for text

The basic config unit in tabby is `TabbyText`. It's a set of text content, highlight group and layout setting.
You may use it in many places. The type definiation is:

```lua
---@class TabbyText
---@field [1] string text content
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
```

There is a util for extract values from highlight:

``` lua
local hl_normal = util.extract_nvim_hl("Normal")
local labal = {
	"  " .. tabid .. " ",
	hl = { fg = hl_normal.fg, bg = hl_normal.bg, style = "bold" },
}
```

### Customize with high level apis

Through setting the `TabbyOption.tabline` to use the high-level api to customize tabby.
You can edit one of the three built-in layouts. (Corresponding to the three preset values)

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

## Customize with low level apis

If built-in layouts do not satisfy you,
you can also use the low-level API to define the tabline from scratch by setting `TabbyOption.components`.

`TabbyOption.components` is a function which return an array of `TabbyComponent`. The `TabbyComponent` is object
like:

```lua
{
    "type": "<component type>",
    -- "... config ..."
}
```

This are all TabbyComponents:

* TabbyComTab

TabbyComTab can receive a tabid to render a tab label.

```lua
---@class TabbyComTab
---@field type "tab"
---@field tabid number
---@field label string|TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText
```

* TabbyComWin

TabbyComWin can receive a winid to render a window label.

```lua
---@class TabbyComWin
---@field type "win"
---@field winid number
---@field label TabbyText
---@field left_sep TabbyText
---@field right_sep TabbyText
```

* TabbyComText

TabbyComText for rendering static text.

```lua
---@class TabbyComText
---@field type "text"
---@field text TabbyText
```

* TabbyComSpring

TabbyComSpring mark a separation point. Each separation point will be print as equal number of spaces.

```lua
---@class TabbyComSpring
---@field type "spring"
```

**Example**

For example, we can use low-level api to define the presets `active_wins_at_end`:

[active_wins_at_end](./examples/low-level-example.lua)

## TODO

- [ ] Rename tab
- [ ] Unique short name for window label
- [ ] Button for close tab and add tab
- [ ] Custom click handler
