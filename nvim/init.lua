-- Entry point: leader keys must be set before lazy.nvim loads any plugin.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

require("pablo.options")
require("pablo.keymaps")
require("pablo.autocmds")
require("pablo.lazy")
