-- Modern setup: nvim-lspconfig's own require('lspconfig').setup{} framework
-- is deprecated. Servers are defined as vim.lsp.Config tables (already
-- shipped by nvim-lspconfig under lsp/*.lua) and turned on with
-- vim.lsp.enable(); mason-lspconfig bridges "Mason installed it" to
-- "vim.lsp.enable() it" via automatic_enable.
--
-- C#: csharp_ls, not omnisharp — it's the Roslyn-workspace-based server
-- (omnisharp is the older HTTP/JSON-RPC design) and ships as a plain Mason
-- package instead of needing an extra plugin like roslyn.nvim. Either way,
-- any C# server needs a `dotnet` runtime on PATH; this machine doesn't have
-- one installed, so csharp_ls will be configured but stay inert for .cs
-- files until dotnet is installed (see README).
local ensure_installed = {
  "lua_ls",
  "basedpyright",
  "ts_ls",
  "angularls",
  "clangd",
  "csharp_ls",
  "jsonls",
  "html",
  "cssls",
}

vim.diagnostic.config({
  virtual_text = { prefix = "●", spacing = 2 },
  underline = true,
  severity_sort = true,
  float = { border = "rounded", source = true },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN] = "",
      [vim.diagnostic.severity.INFO] = "",
      [vim.diagnostic.severity.HINT] = "",
    },
  },
})

vim.api.nvim_create_autocmd("LspAttach", {
  desc = "LSP keymaps (buffer-local, only where a server has attached)",
  callback = function(args)
    local bufnr = args.buf
    local function map(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    map("n", "gd", vim.lsp.buf.definition, "Go to definition")
    map("n", "gD", vim.lsp.buf.declaration, "Go to declaration")
    map("n", "gr", vim.lsp.buf.references, "Show references")
    map("n", "gi", vim.lsp.buf.implementation, "Go to implementation")
    map("n", "K", vim.lsp.buf.hover, "Hover documentation")
    map("n", "<leader>rn", vim.lsp.buf.rename, "Rename symbol")
    map("n", "<leader>ca", vim.lsp.buf.code_action, "Code actions")
    map("n", "<leader>ds", vim.lsp.buf.document_symbol, "Document symbols")
    map("n", "<leader>d", vim.diagnostic.open_float, "Line diagnostic")
    map("n", "[d", function() vim.diagnostic.jump({ count = -1, float = true }) end, "Previous diagnostic")
    map("n", "]d", function() vim.diagnostic.jump({ count = 1, float = true }) end, "Next diagnostic")
  end,
})

return {
  {
    "mason-org/mason.nvim",
    opts = {},
  },
  {
    "mason-org/mason-lspconfig.nvim",
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
      "hrsh7th/cmp-nvim-lsp",
    },
    opts = {
      ensure_installed = ensure_installed,
      automatic_enable = true,
    },
    config = function(_, opts)
      -- Shared capabilities (nvim-cmp completion support) for every server.
      vim.lsp.config("*", {
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })

      require("mason-lspconfig").setup(opts)
    end,
  },
}
