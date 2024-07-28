local jump_to_file = function()
  local line = vim.api.nvim_get_current_line()
  local pattern = "(.*)|(%d+) col (%d+)"
  local path, row, col = string.match(line, pattern)
  if path and row and col then
    vim.cmd(":wincmd k")
    vim.cmd(":e " .. path)
    vim.api.nvim_win_set_cursor(0, { tonumber(row), tonumber(col) })
    vim.cmd(":wincmd j")
  end
end

vim.keymap.set("n", "<CR>", jump_to_file, { noremap = true, silent = true, buffer = true})
