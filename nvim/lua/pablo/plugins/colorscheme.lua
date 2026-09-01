-- Terminal palette this config is built around. Shared with statusline.lua.
local palette = {
  bg = "#0D1117",
  surface = "#161B22",
  border = "#30363D",
  text = "#D8DEE9",
  muted = "#6E7681",
  blue = "#79C0FF",
  cyan = "#56D4DD",
  green = "#56D364",
  yellow = "#E3B341",
  red = "#FF7B72",
  purple = "#D2A8FF",
}

return {
  {
    "projekt0n/github-nvim-theme",
    lazy = false,
    priority = 1000,
    opts = {
      options = {
        transparent = true,
        terminal_colors = true,
      },
      -- Highlight groups called out explicitly in the spec: diagnostics,
      -- floating windows, completion menu, Telescope, nvim-tree.
      -- Lualine gets its own theme table in statusline.lua instead.
      groups = {
        all = {
          Normal = { bg = "NONE" },
          NormalNC = { bg = "NONE" },

          NormalFloat = { bg = palette.surface },
          FloatBorder = { fg = palette.border, bg = palette.surface },

          Pmenu = { bg = palette.surface, fg = palette.text },
          PmenuSel = { bg = palette.blue, fg = palette.bg },
          PmenuSbar = { bg = palette.surface },
          PmenuThumb = { bg = palette.border },

          TelescopeNormal = { bg = palette.surface },
          TelescopeBorder = { fg = palette.border, bg = palette.surface },
          TelescopePromptBorder = { fg = palette.border, bg = palette.surface },
          TelescopeResultsBorder = { fg = palette.border, bg = palette.surface },
          TelescopePreviewBorder = { fg = palette.border, bg = palette.surface },

          NvimTreeNormal = { bg = "NONE" },
          NvimTreeWinSeparator = { fg = palette.border },
          NvimTreeIndentMarker = { fg = palette.border },

          DiagnosticError = { fg = palette.red },
          DiagnosticWarn = { fg = palette.yellow },
          DiagnosticInfo = { fg = palette.blue },
          DiagnosticHint = { fg = palette.cyan },
        },
      },
    },
    config = function(_, opts)
      require("github-theme").setup(opts)

      if not pcall(vim.cmd.colorscheme, "github_dark_default") then
        vim.notify("github-theme failed to load, falling back to habamax", vim.log.levels.WARN)
        vim.cmd.colorscheme("habamax")
      end
    end,
  },
}
