return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      { "<leader>e", "<cmd>NvimTreeToggle<CR>", desc = "Toggle explorer" },
      { "<leader>E", "<cmd>NvimTreeFocus<CR>", desc = "Focus explorer" },
    },
    opts = {
      on_attach = function(bufnr)
        local api = require("nvim-tree.api")

        api.config.mappings.default_on_attach(bufnr)

        local function open_file_and_close()
          local node = api.tree.get_node_under_cursor()
          api.node.open.edit(node)

          if node and node.type == "file" then
            api.tree.close()
          end
        end

        local map_opts = {
          buffer = bufnr,
          noremap = true,
          silent = true,
          nowait = true,
        }
        vim.keymap.set("n", "<CR>", open_file_and_close, map_opts)
      end,
      view = { width = 32 },
      git = { enable = true },
      diagnostics = { enable = true },
      renderer = { icons = { show = { git = true, diagnostics = true } } },
      update_focused_file = { enable = true, update_root = { enable = true } },
      sync_root_with_cwd = true,
      respect_buf_cwd = true,
      -- keep default hijack_directories/hijack_netrw: `nvim <dir>` opening
      -- the tree is expected behavior, not an unexpected replacement.
    },
  },

  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      spec = {
        { "<leader>f", group = "Find" },
        { "<leader>g", group = "Git" },
        { "<leader>d", group = "LSP" },
      },
    },
  },
}
