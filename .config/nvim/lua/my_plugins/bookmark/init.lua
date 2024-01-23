local function open_path()
  local paths = {
    "1. /home/tlp/.dotfiles/.config/nvim/",
    "2. /home/tlp/Documents/cp/",
    "3. /home/tlp/Documents/notes/",
  }
  local index = vim.fn.inputlist(paths)

  if index > 0 and index <= #paths then
    require("telescope.builtin").find_files({ cwd = string.sub(paths[index], 4, #paths[index]) })
  else
    print("Invalid selection")
  end
end

vim.keymap.set("n", "<leader>mb", open_path, { silent = true, noremap = true })
