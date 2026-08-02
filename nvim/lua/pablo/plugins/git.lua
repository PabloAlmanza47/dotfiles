return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    current_line_blame = false, -- inline blame stays opt-in via <leader>gb
    on_attach = function(bufnr)
      local gitsigns = require("gitsigns")
      local function map(mode, lhs, rhs, desc)
        vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
      end

      map("n", "]c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gitsigns.nav_hunk("next")
        end
      end, "Next git hunk")

      map("n", "[c", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gitsigns.nav_hunk("prev")
        end
      end, "Previous git hunk")

      map("n", "<leader>gp", gitsigns.preview_hunk, "Preview git hunk")
      map("n", "<leader>gs", gitsigns.stage_hunk, "Stage git hunk")
      map("n", "<leader>gr", gitsigns.reset_hunk, "Reset git hunk")
      map("n", "<leader>gb", gitsigns.blame_line, "Show line blame")
    end,
  },
}
