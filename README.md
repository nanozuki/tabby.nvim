<!-- panvimdoc-ignore-start -->

# tabby.nvim

A highly configurable, and neovim style tabline plugin. Use your nvim tabs as
a workspace multiplexer!

![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/banner.png)

<!-- panvimdoc-ignore-end -->

## Compatibility and Versions

Compatibility has always been a key consideration for `tabby.nvim`. Since its
inception during the Neovim 0.5 era, the landscape of plugin management and
semantic versioning has not been widely adopted; hence, we have made every
effort to maintain backward compatibility with each release.

However, since then, numerous Neovim APIs have been added, altered, or
deprecated, and the design philosophy of `tabby.nvim` has also gone through
several iterations. Maintaining complete backward compatibility has become
increasingly challenging. Therefore, starting from this version, `tabby.nvim`
will adhere to semantic versioning. Within the same major version, no breaking
changes will be introduced.

At next major version, v3, `tabby.nvim` will cleaner all deprecated apis and
remove all vimscript.

## Features

### Tabline, not bufferline

A line for the vim tab page, not for buffers. A tabpage in vim holds one or
more windows(not buffers). You can easily switch between tab pages to have
several collections of windows to work on different things.

Tabline can help you use multiple tabs. Meanwhile, the bufferline is simply an
array of opened files. As a result, Bufferline limits the power of vim,
especially when editing a large workspace with many opened files.

For example, you are writing a backend service:

```
- Tab1: nvim-tree, controller/user.go, entity/user.go
- Tab2: nvim-tree, pkg/cache.go, redis/client.go
- Tab3: Terminal
- Tab4: Neogit.nvim
```

### Highly configurable

Tabby provides a highly configurable way to set up your personalized tabline.
There is no DSL for config; you can write any lua codes following the type hint.
But also, Tabby provides some presets for quick start and as your example.

### Tab rename

You can rename a tab by `Tabby rename_tab <tabname>`. Display the tab name by
`tab.name()` (reference: [Tab](#Tab)) in your config. Config fallback name by
[Line-Option](#Line-Option)

### Window picker

Use command `Tabby pick_window` to open a selector to pick window in tabpages.
This picker use native neovim selector, you can use a general UI plugin to
enhance the appearance.

### Jump mode for tabs

Inspired by [barbar.nvim](https://github.com/romgrk/barbar.nvim?tab=readme-ov-file#jump-to-buffer-mode).
Type one key to jump to a tabpage.

<!-- panvimdoc-ignore-start -->

![](https://github.com/nanozuki/tabby.nvim/wiki/assets/tab-jump-mode.png)

<!-- panvimdoc-ignore-end -->

Use command `Tabby jump_to_tab` to get into jump mode. In jump mode, each tab
have a key which displayed in tabline by `tab.jump_key()`. You can check if in
jump mode by `tab.in_jump_mode()`. (reference: [Tab](#Tab))

For example in your config:

```lua
tab.in_jump_mode() and tab.jump_key() or tab.number()
```

The jump char is also displayed in presets.

## Playground

Want to try your new config with no fear? Want to reproduct/debug a problem?
Want to contribute? Use the playground!

1. Clone this repository, or open the directory your plugin manager installed
   tabby.nvim.
2. Put your config in 'playground/config.lua'
3. Execute `make play`, into a temporary neovim to check the config.
4. Use `make clear-play` to clean the change.

## Install

Use your favorite plugin manager or script to installing 'nanozuki/tabby.com'.
If you use `lazy.nvim`, you can refer the following example:

```lua
{
  'nanozuki/tabby.nvim',
  -- event = 'VimEnter', -- if you want lazy load, see below
  dependencies = 'nvim-tree/nvim-web-devicons',
  config = function()
    -- configs...
  end,
}
```

You don't need lazy load since 'tabby.nvim' is not slow. If you really want,
you can use `VimEnter` or `VeryLazy` or anything else you like. Some of them
(like `VeryLazy`) will make the raw tabline render first, and re-render to
tabby's line quickly.

## Setup

### Tabline option

At default, neovim only display tabline when there are at least two tab pages.
If you want always display tabline:

```lua
vim.o.showtabline = 2
```

### Save and restore in session

You can save and restore tab layout and tab names in session, by adding word
`tabpages`(for layout) and `globals`(for tab names) to `vim.opt.sessionoptions`.
This is a valid `sessionoptions`:

```lua
vim.opt.sessionoptions = 'curdir,folds,globals,help,tabpages,terminal,winsize'
```

### Setup tabby.nvim

And you can setup your own tabline like this (check [Customize](#Customize) for
more details):

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
require('tabby').setup({
  line = function(line)
    return {
      {
        { '  ', hl = theme.head },
        line.sep('', theme.head, theme.fill),
      },
      line.tabs().foreach(function(tab)
        local hl = tab.is_current() and theme.current_tab or theme.tab
        return {
          line.sep('', hl, theme.fill),
          tab.is_current() and '' or '󰆣',
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
  end,
  -- option = {}, -- setup modules' option,
})
```

> In recent versions, we use `require('tabby.tabline').set(fn, opt?)` to set up
> the tabline. You can continue to use this.

### Examples and Gallery

These are some awesome examples shared by tabby.nvim users! Also welcome to
share your own!

[Discussions: show and tell](https://github.com/nanozuki/tabby.nvim/discussions/categories/show-and-tell)

### Presets

If you want to quick start? That's fine, you can [Use Preset Configs](#Use-Presets). And you can use theme of [lualine](https://github.com/nvim-lualine/lualine.nvim) in presets.

### Commands

- `Tabby rename_tab <tabname>`: Rename tab. Use name in line by `tab.name()`
  (ref: [Tab](#Tab)). Config fallback name by [Line-Option](#Line-Option)
- `Tabby pick_window`: Open a selector to pick window in tabpages.
- `Tabby jump_to_tab`: Get one key to jump to tabpage, each keys are displayed
  in tabline by `tab.jump_key()`

### Key mapping example

Tabby uses native nvim tab, so you can directly use nvim tab operation. Maybe
you want to map some operation. For example:

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

```vimdoc
gt					*i_CTRL-<PageDown>* *i_<C-PageDown>*
		Go to the next tab page.  Wraps around from the last to the
		first one.
{count}gt	Go to tab page {count}.  The first tab page has number one.
g<Tab>		Go to previous (last accessed) tab page.
gT		Go to the previous tab page.  Wraps around from the first one
		to the last one.
```

The `{count}` is the number displayed in presets.

## Customize

Customize tabby with `require('tabby').setup(opts)`:

```vimdoc
tabline.set({opts})                                             *tabby.setup()*
    Set tabline renderer function

    Parameters: ~
      • {opts}   Options dict:
                 • line (funtion) required: renderer function, receive a line
                   (|tabby.object.line|), return a node (|tabby.object.node|).
                 • option (|LineOption|) optional: renderer option.
```

All you need is to provide a render function, that use the variable `line`
(ref: [Line](#Line)) to complete tabline node (ref: [Node](#Node)). The `line`
variable gathered all features the tabby provided. And you can use `opt` (ref:
[Line Option](#Line Option)) to customize some behaviors.

The render function will be called every time the nvim redraws tabline. You can
use any valid neovim lua code to contracture the Node in this function. For
example, if you want display current directory in tabline, you can do like
this:

```lua
require('tabby').setup({
  line = function(line)
    local cwd = ' ' .. vim.fn.fnamemodify(vim.fn.getcwd(), ':t') .. ' '
    return {
        {
            { cwd, hl = theme.head },
            line.sep('', theme.head, theme.line),
        },
        ".....",
    }
  end,
  option = {},
})
```

### Line

```vimdoc
line.tabs().foreach({callback})                    *tabby.line.tabs().foreach()*
    Use callback function to renderer every tabs.

    Parameters: ~
        {callback}  Function, receive a Tab |tabby-tab|, return a
                    Node |tabby-node|. Skip render when return is empty string.

    Return: ~
        Node |tabby-node|, rendered result of all tabs.

line.wins({filter...}).foreach({callback})         *tabby.line.wins().foreach()*
    Use callback function to renderer every wins.

    Parameters: ~
        {filter...}  Filter functions. Each function receive a |tabby-win| and
                     return a boolean. If filter return false, this window won't
                     be displayed in tabline.
        {callback}   Function, receive a Win |tabby-win|, return a
                     Node |tabby-node|. Skip render when return is empty string.

    Return: ~
        Node |tabby-node|, rendered result of all wins.

    Example: ~
      - Don't display NvimTree: >
            local function no_nvimtree(win)
              return not string.match(win.buf_name(), 'NvimTree')
            end
            ...
            line.wins(no_nvimtree).foreach(function
              ...
            end)
<

                                            *tabby.line.wins_in_tab().foreach()*
line.wins_in_tab({tabid}, {filter...}).foreach({callback})
    Use callback function to renderer every wins in specified tab.

    Parameters: ~
        {tabid}      Number, tab id
        {filter...}  Filter functions. Each function receive a |tabby-win| and
                     return a boolean. If filter return false, this window won't
                     be displayed in tabline.
        {callback}   Function, receive a Win |tabby-win|, return a
                     Node |tabby-node|. Skip render when return is empty string.

    Return: ~
        Node |tabby-node|, rendered result of all wins in specified tab.

    Example: ~
        - Don't display NvimTree: See |tabby.line.wins().foreach()|.

                                            *tabby.line.bufs().foreach()*
line.bufs({filter...}).foreach({callback})
    Use callback function to renderer every bufs.

    Parameters: ~
        {filter...}  Filter functions. Each function receive a |tabby-buf| and
                     return a boolean. If filter return false, this window won't
                     be displayed in tabline.
        {callback}   Function, receive a Buf |tabby-buf|, return a
                     Node |tabby-node|. Skip render when return is empty string.

    Return: ~
        Node |tabby-node|, rendered result of all bufs.

line.spacer()                                              *tabby.line.spacer()*
    Separation point between alignment sections. Each section will be separated
    by an equal number of spaces.

    Return: ~
        Node |tabby-node|, spacer node.

line.truncate_point()                              *tabby.line.truncate_point()*
    Separation point between alignment sections. Each section will be separated
    by an equal number of spaces.

    Return: ~
        Node |tabby-node|, spacer node.

line.sep({symbol}, {hl}, {back_hl})            *tabby.line.sep()*
    Make a separator, and calculate highlight.

    Parameters: ~
        [  ██████████████   ]
           |          |     |
           symbol     hl    back_hl
        {symbol}    string, separator symbol
        {hl}        Highlight |tabby-highlight|, current highlight
        {back_hl}   Highlight |tabby-highlight|, highlight in back

    Return: ~
        Node |tabby-node|, sep node.

line.api                                                        *tabby.line.api*
    Tabby gathered some neovim lua api in this object. Maybe help you to build
    lines. Details: |tabby-api|.
```

### Line Option

```lua
{
    tab_name = {
        name_fallback = function(tabid)
            return "fallback name"
        end
    },
    buf_name = {
        mode = "'unique'|'relative'|'tail'|'shorten'",
    }
}
```

#### tab_name

Use command `Tabby rename_tab <tabname>` to rename tab. Use `tab.name()` (ref:
[Tab](#Tab)) to add in your config. If no name provided, `tab.name()` will
display fallback name. The default fallback name is current window's buffer name.

You can change the fallback by provide a function in
`opt.tab_name.name_fallback`.

#### buf_name

There are four mode of buffer name. If current directory is "~/project" and
there are three buffers:

- "~/project/a_repo/api/user.py"
- "~/project/b_repo/api/user.py"
- "~/project/b_repo/api/admin.py"

the result of every mode are:

- unique: "a_repo/api/user.py", "b_repo/api/user.py", "admin.py"
- relative: "a_repo/api/user.py", "b_repo/api/user.py", "b_repo/api/admin.py"
- tail: "user.py", "user.py", "admin.py"
- shorten: "r/a/user.py", "r/b/user.py", "r/b/admin.py"

### Tab

```vimdoc
tab.id                                                            *tabby.tab.id*
    id of tab, tab handle for nvim api.

tab.current_win()                                       *tabby.ab.current_win()*

    Return: ~
        Win |tabby-win|, current window.

tab.wins()                                                    *tabby.tab.wins()*

    Return: ~
        An Array of Win |tabby-win|, current window.

tab.wins().foreach({callback})                      *tabby.tab.wins().foreach()*
    See |tabby.line.wins().foreach()|.

tab.number()                                                *tabby.tab.number()*

    Return: ~
        Number, tab's order, start from 1.

tab.is_current()                                        *tabby.tab.is_current()*

    Return: ~
        Boolean, if this tab is current tab.

tab.name()                                               *tabby.tabby.tab.name()*

    Return: ~
        String, tab name. If name is not set, use option
        ".tab_name.name_fallback()" in LineOption |tabby-line-option|.

tab.close_btn({symbol})                                  *tabby.tab.close_btn()*
    Make a close button of this tab.

    Parameters: ~
        {symbol}  String, a symbol of close button.

    Return: ~
        Node |tabby-node|, close button node.

tab.jump_key()                                            *tabby.tab.jump_key()*
    In jump mode, return a key to jump to this tab, otherwise return empty
    string.

    Return: ~
        String, a key to jump to this tab.

tab.in_jump_mode()                                    *tabby.tab.in_jump_mode()*
    Return: ~
        Boolean, if this tab is in jump mode.
```

### Win

```vimdoc
win.id                                                            *tabby.win.id*
    id of window, win handle for nvim api.

win.tab()                                                      *tabby.win.tab()*

    Return: ~
        Tab |tabby-tab|, tab of this window.

win.buf()                                                      *tabby.win.buf()*

    Return: ~
        Buf |tabby-buf|, buf of the window.

win.is_current()                                        *tabby.win.is_current()*

    Return: ~
        Boolean, if this window is current.

win.file_icon()                                          *tabby.win.file_icon()*
    Get file icon of filetype. You need to installed plugin
    'kyazdani42/nvim-web-devicons'.

    Return: ~
        Node |tabby-node|, file icon.

win.buf_name()                                                *tabby.win.name()*

    Return: ~
        String, buffer name of this window. You can specify the form by using
        option ".buf_name.mode" in LineOption |tabby-line-option|.
```

### Buf

Object for buffer.

```vimdoc
buf.id                                                            *tabby.buf.id*
    id of buffer, buffer handle for nvim api.


buf.is_current()                                        *tabby.buf.is_current()*

    Return: ~
        Boolean, if this buffer is a buffer of the current window.


buf.is_changed()                                        *tabby.buf.is_changed()*
    Get if buffer is changed.

    Return: ~
        boolean, true if there are unwritten changes, false if not
        <https://neovim.io/doc/user/options.html#'buftype'> for details.


buf.file_icon()                                          *tabby.buf.file_icon()*
    Get file icon of filetype. You need to installed plugin
    'kyazdani42/nvim-web-devicons'.

    Return: ~
        Node |tabby-node|, file icon.


buf.name()                                                    *tabby.buf.name()*

    Return: ~
        String, name of this buffer. You can specify the form by using
        option ".buf_name.mode" in LineOption |tabby-line-option|.


buf.type()                                                    *tabby.buf.type()*
    Get buftype option.

    Return: ~
        buftype, normal buffer is an empty string. check |buftype| or
        <https://neovim.io/doc/user/options.html#'buftype'> for details.
```

### Node

Node is the rendered unit for tabby. Node is a recursive structure. It can be:

- A string: "nvim"
- A Number: 12
- A table containing a Node or an array of Node, with an optional property 'hl'
  to set highlight. Example:

  ```lua
  -- node 1
  {
    "tab1", 100
    hl = "TabLineSel"
  }
  -- node 2
  {
    "text 1"
    {
        "text 2",
        hl = "Info",
    },
    "text3",
    hl = "Fill",
  }
  ```

### Highlight

There are two ways to declare a highlight:

- Use the name of neovim highlight group: "TabLineSel"
- Define "background", "foreground" and "style" in lua table:
  `{ fg = "#000000", bg = "#ffffff" style = "bold" } `.
  The "style" can be:
  - bold
  - underline
  - underlineline, double underline
  - undercurl, curly underline
  - underdot, dotted underline
  - underdash, dashed underline
  - strikethrough
  - italic

### API

```vimdoc
api.get_tabs()                                            *tabby.api.get_tabs()*
    Get all tab ids

api.get_tab_wins({tabid})                             *tabby.api.get_tab_wins()*
    Get an winid array in specified tabid.

api.get_current_tab()                              *tabby.api.get_current_tab()*
    Get current tab's id.

api.get_tab_current_win({tabid})               *tabby.api.get_tab_current_win()*
    Get tab's current win's id.

api.get_tab_number({tabid})                         *tabby.api.get_tab_number()*
    Get tab's number.

api.get_wins()                                            *tabby.api.get_wins()*
    Get all windows, except floating window.

api.get_win_tab({winid})                               *tabby.api.get_win_tab()*
    Get tab id of specified window.

api.is_float_win({winid})                             *tabby.api.is_float_win()*
    Return true if this window is floating.

api.is_not_float_win({winid})                     *tabby.api.is_not_float_win()*
    Return true if this window is not floating.

api.get_bufs()                                            *tabby.api.get_bufs()*
    Get all listed buf ids
```

## Use Presets

You can use presets for a quick start. The preset config uses nerdfont,
and you should use a nerdfont-patched font to display that correctly.

To use preset, you can use `setup({ preset , option? })`, for example:

```lua
require('tabby').setup({
  preset = 'active_wins_at_tail',
  option = {
    theme = {
      fill = 'TabLineFill',       -- tabline background
      head = 'TabLine',           -- head element highlight
      current_tab = 'TabLineSel', -- current tab label highlight
      tab = 'TabLine',            -- other tab label highlight
      win = 'TabLine',            -- window highlight
      tail = 'TabLine',           -- tail element highlight
    },
    nerdfont = true,              -- whether use nerdfont
    lualine_theme = nil,          -- lualine theme name
    tab_name = {
      name_fallback = function(tabid)
        return tabid
      end,
    },
    buf_name = {
      mode = "'unique'|'relative'|'tail'|'shorten'",
    },
  },
})
```

The `{opt}` is an optional parameter, including all option in
[Line Option](#Line-Option). And has some extending options:

- {theme}, the example shows the default value.
- {nerdfont}, whether use nerdfont, default is true.
- {lualine_theme}, use lualine theme to make `theme`. if `theme` is set, this option will be ignored. default is empty.

There are five `{name}` of presets:

- active_wins_at_tail

  <!-- panvimdoc-ignore-start -->

  ![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/active_wins_at_tail.png)

  <!-- panvimdoc-ignore-end -->

  Put all windows' labels in active tabpage at end of whold tabline.

- active_wins_at_end

  Put all windows' labels in active tabpage after all tags label. In-active
  tabpage's window won't display.

  <!-- panvimdoc-ignore-start -->

  ![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/tabby-default-1.png)

  <!-- panvimdoc-ignore-end -->

- tab_with_top_win

  Each tab lab with a top window label followed. The `top window` is the focus
  window when you enter a tabpage.

  <!-- panvimdoc-ignore-start -->

  ![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/tab_with_top_win.png)

  <!-- panvimdoc-ignore-end -->

- active_tab_with_wins

  Active tabpage's windows' labels is displayed after the active tabpage's label.

  <!-- panvimdoc-ignore-start -->

  ![](https://raw.githubusercontent.com/wiki/nanozuki/tabby.nvim/assets/active_tab_with_wins.png)

  <!-- panvimdoc-ignore-end -->

- tab_only

  No windows label, only tab. and use focus window to name tab

  <!-- panvimdoc-ignore-start -->

  ![](https://user-images.githubusercontent.com/4208028/136306954-815d01df-bcf1-4e88-8621-8fb7aca4eac3.png)

  <!-- panvimdoc-ignore-end -->
