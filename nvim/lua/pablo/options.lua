local opt = vim.opt

-- UI
opt.number = true
opt.relativenumber = true
opt.cursorline = true
opt.signcolumn = "yes"
opt.termguicolors = true
opt.wrap = false
opt.scrolloff = 8
opt.sidescrolloff = 8
opt.mouse = "a"

-- whitespace / indentation (default: 4 spaces; per-filetype overrides below)
opt.expandtab = true
opt.shiftwidth = 4
opt.tabstop = 4
opt.softtabstop = 4
opt.smartindent = true
opt.list = true
opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- search
opt.ignorecase = true
opt.smartcase = true
opt.hlsearch = true

-- splits
opt.splitright = true
opt.splitbelow = true

-- clipboard: reuse the system clipboard when a provider is available
-- (no-op otherwise, so this is safe on any WSL/Windows Terminal setup)
opt.clipboard = "unnamedplus"

-- files / undo
opt.swapfile = false
opt.undofile = true
opt.undodir = vim.fn.stdpath("state") .. "/undo"

-- completion (nvim-cmp expects menuone,noselect)
opt.completeopt = { "menu", "menuone", "noselect" }

-- misc
opt.updatetime = 250
opt.confirm = true -- ask instead of erroring on :q with unsaved changes

-- 2-space filetypes; everything else keeps the 4-space default above
local two_space_filetypes = {
  "javascript", "javascriptreact",
  "typescript", "typescriptreact",
  "json", "jsonc",
  "html", "css", "scss",
  "yaml",
  "lua",
}

vim.api.nvim_create_autocmd("FileType", {
  desc = "Use 2-space indentation for web/config/Lua filetypes",
  pattern = two_space_filetypes,
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.softtabstop = 2
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  desc = "Wrap prose filetypes cleanly",
  pattern = "*",
  callback = function()
    if vim.bo.filetype == "markdown" or vim.bo.filetype == "text" then
      vim.wo.wrap = true
      vim.wo.linebreak = true
      vim.wo.breakindent = true
      vim.wo.showbreak = "↪ "
    else
      vim.wo.wrap = false
    end
  end,
})
