-- Entry point: leader keys must be set before lazy.nvim loads any plugin.
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Copy to the terminal clipboard over SSH using Neovim's built-in OSC 52 provider.
-- Paste from the unnamed register to avoid terminal clipboard queries/timeouts.
local osc52 = require("vim.ui.clipboard.osc52")
local function paste_from_unnamed()
  return {
    vim.fn.split(vim.fn.getreg(""), "\n"),
    vim.fn.getregtype(""),
  }
end

vim.g.clipboard = {
  name = "OSC 52",
  copy = {
    ["+"] = osc52.copy("+"),
    ["*"] = osc52.copy("*"),
  },
  paste = {
    ["+"] = paste_from_unnamed,
    ["*"] = paste_from_unnamed,
  },
}

require("pablo.options")
require("pablo.keymaps")
require("pablo.autocmds")
require("pablo.lazy")
