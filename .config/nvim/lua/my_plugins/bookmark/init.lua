local function open_path()
  local paths = {
    "1. /home/tlp/.dotfile/.config/nvim/",
    "2. /home/tlp/Documents/code/cp/",
    "3. /home/tlp/Documents/code/notes/",
  }
  local index = vim.fn.inputlist(paths)

  if index > 0 and index <= #paths then
    vim.cmd("Joshuto " .. string.sub(paths[index], 4, string.len(paths[index])))
  else
    print("Invalid selection")
  end
end

vim.keymap.set("n", "<leader>mb", open_path, { silent = true, noremap = true })
