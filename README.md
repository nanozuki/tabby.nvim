# tabby.nvim

A minimal, configurable, neovim style tabline.

### status

Need to improve documents.

## Quick start

if you use packer:

```lua
use	{
    "nanozuki/tabby.nvim",
    requires = "kyazdani42/nvim-web-devicons",
    config = function() require("tabby").setup() end,
}
```

## Use presets

```lua
require("tabby").setup({
    tabline = require("tabby.presets").tab_with_top_win,
})
```

there are three [presets](https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/presets.lua) for now:

```
active_tab_with_wins
active_wins_at_end
tab_with_top_win
```

## Customize with high level apis

use `tabby.tabline.*` to write your own option.tabline.

https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/tabline.lua

## Customize with low level apis

use `tabby.component.*` to write your own option.components

https://github.com/nanozuki/tabby.nvim/blob/main/lua/tabby/component.lua
