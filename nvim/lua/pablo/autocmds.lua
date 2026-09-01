local augroup = vim.api.nvim_create_augroup("pablo", { clear = true })

-- Briefly highlight yanked text.
vim.api.nvim_create_autocmd("TextYankPost", {
  group = augroup,
  desc = "Highlight yanked text",
  callback = function()
    vim.hl.on_yank({ timeout = 150 })
  end,
})

-- Restore cursor to the last known position when reopening a file.
vim.api.nvim_create_autocmd("BufReadPost", {
  group = augroup,
  desc = "Restore cursor position",
  callback = function(args)
    local mark = vim.api.nvim_buf_get_mark(args.buf, '"')
    local lcount = vim.api.nvim_buf_line_count(args.buf)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
})

-- Hide relative numbers while typing, restore them on leaving insert mode.
vim.api.nvim_create_autocmd("InsertEnter", {
  group = augroup,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = false
    end
  end,
})
vim.api.nvim_create_autocmd("InsertLeave", {
  group = augroup,
  callback = function()
    if vim.wo.number then
      vim.wo.relativenumber = true
    end
  end,
})

-- Save modified named file buffers when leaving them or when Neovim loses focus.
local autosave_filetypes = {
  help = true,
  NvimTree = true,
  TelescopePrompt = true,
  TelescopeResults = true,
}

vim.api.nvim_create_autocmd({ "BufLeave", "FocusLost" }, {
  group = augroup,
  desc = "Autosave modified file buffers",
  callback = function(args)
    local buffer = vim.bo[args.buf]
    if
      not buffer.modified
      or not buffer.modifiable
      or buffer.readonly
      or buffer.buftype ~= ""
      or vim.api.nvim_buf_get_name(args.buf) == ""
      or autosave_filetypes[buffer.filetype]
    then
      return
    end

    vim.api.nvim_buf_call(args.buf, function()
      vim.cmd("silent update")
    end)
  end,
})
