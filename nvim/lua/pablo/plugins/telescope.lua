-- Telescope's own file/grep finders already fall back gracefully:
-- find_files uses fd if present, else `rg --files`, else `find` — and both
-- rg and the fd path respect .gitignore automatically. Nothing to special-case
-- here even though this machine has ripgrep but no fd/fdfind installed.
local function project_root()
  return vim.fs.root(0, { ".git" }) or vim.uv.cwd()
end

return {
  "nvim-telescope/telescope.nvim",
  dependencies = { "nvim-lua/plenary.nvim" },
  cmd = "Telescope",
  keys = {
    {
      "<leader>ff",
      function() require("telescope.builtin").find_files({ cwd = project_root(), hidden = true }) end,
      desc = "Find files",
    },
    {
      "<leader>fg",
      function() require("telescope.builtin").live_grep({ cwd = project_root() }) end,
      desc = "Find text in project",
    },
    {
      "<leader>fb",
      function() require("telescope.builtin").buffers(require("telescope.themes").get_dropdown()) end,
      desc = "Find buffers",
    },
    {
      "<leader>fr",
      function() require("telescope.builtin").oldfiles() end,
      desc = "Find recent files",
    },
    {
      "<leader>fh",
      function() require("telescope.builtin").help_tags(require("telescope.themes").get_dropdown()) end,
      desc = "Find help",
    },
    {
      "<leader>fc",
      function() require("telescope.builtin").grep_string({ cwd = project_root() }) end,
      desc = "Find current word",
    },
  },
  opts = {
    defaults = {
      file_ignore_patterns = {
        "%.git/",
        "node_modules/",
        "bin/",
        "obj/",
        "dist/",
        "%.venv/",
        "__pycache__/",
      },
      vimgrep_arguments = {
        "rg",
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
        "--smart-case",
        "--hidden",
      },
    },
    pickers = {
      find_files = { hidden = true },
    },
  },
}
