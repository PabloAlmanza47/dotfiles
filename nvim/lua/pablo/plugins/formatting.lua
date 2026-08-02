-- Formatter binaries (stylua, prettier, ruff, clang-format, csharpier) are
-- plain Mason packages too: `:MasonInstall stylua prettier ruff clang-format
-- csharpier` (see README). Conform's built-in "prettier"/others already
-- prefer a project-local install (node_modules/.bin/...) over a global one.
local formatters_by_ft = {
  lua = { "stylua" },
  python = { "ruff_format" },
  javascript = { "prettier" },
  javascriptreact = { "prettier" },
  typescript = { "prettier" },
  typescriptreact = { "prettier" },
  json = { "prettier" },
  jsonc = { "prettier" },
  html = { "prettier" },
  css = { "prettier" },
  scss = { "prettier" },
  yaml = { "prettier" },
  markdown = { "prettier" },
  c = { "clang_format" },
  cpp = { "clang_format" },
  cs = { "csharpier" },
}

return {
  "stevearc/conform.nvim",
  cmd = { "ConformInfo" },
  keys = {
    {
      "<leader>f",
      function()
        require("conform").format({ async = true, lsp_format = "fallback", timeout_ms = 2000 })
      end,
      mode = { "n", "v" },
      desc = "Format buffer",
    },
  },
  opts = {
    formatters_by_ft = formatters_by_ft,
    -- Only auto-format filetypes we've explicitly configured a formatter for.
    format_on_save = function(bufnr)
      if not formatters_by_ft[vim.bo[bufnr].filetype] then
        return
      end
      return { timeout_ms = 500, lsp_format = "fallback" }
    end,
    notify_on_error = true,
  },
}
