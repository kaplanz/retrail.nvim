# nvim-retrail

Retrail is a small Neovim plugin for managing trailing whitespace. It has two
main features:
1. Highlight trailing whitespace.
1. Trim trailing whitespace upon `:write`.

## Installation

Install this plugin using your favorite plugin manager. For example, using
[packer]:

```lua
use "kaplanz/nvim-retrail"
```

To get started with the default configuration, add:

```lua
require("retrail").setup()
```

## Configuration

While the [defaults] should work for most users out of the box, the following
options can be configured as such:

```lua
require("retrail").setup {
  -- Highlight group to use for trailing whitespace.
  hlgroup = "Search",
  -- Pattern to match trailing whitespace against. Edit with caution!
  pattern = "\\v((.*%#)@!|%#)\\s+$",
  -- Enabled filetypes.
  filetype = {
    -- Strictly enable only on `include`ed filetypes. When false, only disabled
    -- on an `exclude`ed filetype.
    strict = false,
    -- Included filetype list.
    include = {},
    -- Excluded filetype list. Overrides `include` list.
    exclude = {
      "",
      "aerial",
      "alpha",
      "checkhealth",
      "cmp_menu",
      "diff",
      "help",
      "lazy",
      "lspinfo",
      "man",
      "mason",
      "TelescopePrompt",
      "Trouble",
      "WhichKey",
    },
  },
  -- Trim on write behaviour.
  trim = {
    -- Auto trim on BufWritePre
    auto = true,
    -- Trailing whitespace as highlighted.
    whitespace = true,
    -- Final blank (i.e. whitespace only) lines.
    blanklines = false,
  }
}
```

<!-- Reference-style links -->
[defaults]: ./lua/retrail/config/defaults.lua
[packer]:   https://github.com/wbthomason/packer.nvim
