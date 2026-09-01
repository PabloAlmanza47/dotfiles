-- Terminal palette (kept in sync with colorscheme.lua's copy).
local colors = {
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

local theme = {
  normal = {
    a = { bg = colors.blue, fg = colors.bg, gui = "bold" },
    b = { bg = "NONE", fg = colors.text },
    c = { bg = "NONE", fg = colors.muted },
  },
  insert = { a = { bg = colors.green, fg = colors.bg, gui = "bold" } },
  visual = { a = { bg = colors.purple, fg = colors.bg, gui = "bold" } },
  replace = { a = { bg = colors.red, fg = colors.bg, gui = "bold" } },
  command = { a = { bg = colors.yellow, fg = colors.bg, gui = "bold" } },
  inactive = {
    a = { bg = "NONE", fg = colors.muted },
    b = { bg = "NONE", fg = colors.muted },
    c = { bg = "NONE", fg = colors.muted },
  },
}

-- Collapse the less essential sections in narrow (e.g. vsplit) windows.
local function hide_when_narrow()
  return vim.fn.winwidth(0) > 80
end

return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  event = "VeryLazy",
  opts = {
    options = {
      theme = theme,
      component_separators = "",
      section_separators = "",
      globalstatus = true,
    },
    sections = {
      lualine_a = { "mode" },
      lualine_b = { "branch", "diff" },
      lualine_c = { "diagnostics", { "filename", path = 1 } },
      lualine_x = { { "filetype", cond = hide_when_narrow }, { "encoding", cond = hide_when_narrow } },
      lualine_y = { { "progress", cond = hide_when_narrow } },
      lualine_z = { "location" },
    },
  },
}
