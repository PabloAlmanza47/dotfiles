-- nvim-treesitter's `main` branch (targets Neovim 0.11+/nightly) replaced
-- require('nvim-treesitter.configs').setup{...} with a plain install list
-- plus vim.treesitter.start() per filetype. Indentation via treesitter is
-- still marked experimental upstream, so it's deliberately left off here.
local parsers = {
  "lua", "vim", "vimdoc",
  "python",
  "javascript", "typescript", "tsx",
  "html", "css",
  "json",
  "markdown", "markdown_inline",
  "c", "cpp", "c_sharp",
  "bash",
  "sql",
}

local highlight_filetypes = {
  "lua", "vim", "help",
  "python",
  "javascript", "javascriptreact", "typescript", "typescriptreact",
  "html", "css",
  "json", "jsonc",
  "markdown",
  "c", "cpp", "cs",
  "bash", "sh",
  "sql",
}

return {
  "nvim-treesitter/nvim-treesitter",
  branch = "main",
  build = ":TSUpdate",
  lazy = false,
  config = function()
    if vim.fn.executable("tree-sitter") ~= 1 then
      -- Upstream requires the standalone tree-sitter CLI (not npm's
      -- tree-sitter-cli) to compile parsers; see README for install steps.
      -- Skip nvim-treesitter's own setup entirely in this state: calling it
      -- with no parsers installed makes Neovim's *built-in* ftplugins (e.g.
      -- ftplugin/lua.lua, which call vim.treesitter.start() unconditionally)
      -- hard-error instead of silently falling back — confirmed by testing
      -- `nvim -u NONE` (no crash) vs this config with setup() called (crash).
      vim.notify(
        "nvim-treesitter: `tree-sitter` CLI not found, skipping setup (see README)",
        vim.log.levels.WARN
      )
      return
    end

    require("nvim-treesitter").setup({
      install_dir = vim.fn.stdpath("data") .. "/site",
    })
    require("nvim-treesitter").install(parsers)

    vim.api.nvim_create_autocmd("FileType", {
      pattern = highlight_filetypes,
      callback = function()
        -- pcall: a parser that isn't installed yet (still downloading) or
        -- fails to build must never break opening the buffer.
        pcall(vim.treesitter.start)
      end,
    })
  end,
}
