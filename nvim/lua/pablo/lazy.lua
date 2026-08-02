-- Bootstrap lazy.nvim into the standard Neovim data directory.
-- The old vendored copy at ~/.config/nvim/lazy/ is left in place as a
-- legacy backup (see README.md) and is no longer referenced anywhere.
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.uv.fs_stat(lazypath) then
  local out = vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
  if vim.v.shell_error ~= 0 then
    vim.api.nvim_echo({
      { "Failed to clone lazy.nvim:\n", "ErrorMsg" },
      { out, "WarningMsg" },
    }, true, {})
    return
  end
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  spec = {
    { import = "pablo.plugins" },
  },
  lockfile = vim.fn.stdpath("config") .. "/lazy-lock.json",
  change_detection = {
    enabled = true,
    notify = true,
  },
  checker = {
    enabled = false, -- opt in later if you want background update checks
  },
  install = {
    colorscheme = { "github_dark_default", "habamax" },
  },
})
