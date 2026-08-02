-- Global keymaps not tied to a specific plugin.
-- Plugin-specific keymaps (Telescope, nvim-tree, LSP, Gitsigns, Conform) live
-- next to their plugin spec in lua/pablo/plugins/, wired via lazy.nvim's
-- own `keys` field or an attach autocmd.
local map = vim.keymap.set

map("n", "<leader>w", "<cmd>write<CR>", { desc = "Save file" })
map("n", "<leader>q", "<cmd>close<CR>", { desc = "Close window" })
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlight" })

map("v", "<A-j>", ":move '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":move '<-2<CR>gv=gv", { desc = "Move selection up" })
