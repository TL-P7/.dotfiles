local function open_path()
  local home = vim.fn.getenv('HOME')
  local paths = {
    "1. " .. home .. "/.dotfiles/.config/nvim/",
    "2. " .. home .. "/Nutstore Files/code/cp/",
    "3. " .. home .. "/Nutstore Files/code/notes/",
    "4. " .. home .. "/.dotfiles/.config/"
  }

  local prompt = "1.nvim 2.cp 3.notes 4.config Select a path: "

  -- modify the inputlist method because it doesn't work properly, find another way
  -- local index = vim.fn.inputlist(paths)

  local index
  vim.ui.input({ prompt = prompt }, function(input)
    index = tonumber(input)
  end)

  if index > 0 and index <= #paths then
    require("telescope.builtin").find_files({ cwd = string.sub(paths[index], 4, #paths[index]), hidden = true })
  else
    print("Invalid selection")
  end
end

vim.keymap.set("n", "<leader>mb", open_path, { silent = true, noremap = true, desc = "bookmark" })
