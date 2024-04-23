local function open_path()
  local paths = {
    "1. /home/tlp/.dotfiles/.config/nvim/",
    "2. /home/tlp/Nutstore Files/code/cp/",
    "2. /home/tlp/Nutstore Files/code/notes/",
    "4. /home/tlp/.dotfiles/.config/",
  }
  local index = vim.fn.inputlist(paths)

  if index > 0 and index <= #paths then
    require("telescope.builtin").find_files({ cwd = string.sub(paths[index], 4, #paths[index]) })
  else
    print("Invalid selection")
  end
end

vim.keymap.set("n", "<leader>mb", open_path, { silent = true, noremap = true, desc = "bookmark"})
