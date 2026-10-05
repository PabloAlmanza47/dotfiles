-- Entry point: leader keys must be set before lazy.nvim loads any plugin.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Use OSC52 for clipboard copying over SSH (e.g. Windows Terminal -> Ubuntu VM).
-- This makes the + and * registers copy through the terminal to the local clipboard.
vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = require("vim.ui.clipboard.osc52").copy("+"),
    ["*"] = require("vim.ui.clipboard.osc52").copy("*"),
  },
  paste = {
    ["+"] = function()
      return {
        vim.fn.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
      }
    end,
    ["*"] = function()
      return {
        vim.fn.split(vim.fn.getreg(""), "\n"),
        vim.fn.getregtype(""),
      }
    end,
  },
}

require("pablo.options")
require("pablo.keymaps")
require("pablo.autocmds")
require("pablo.lazy")
