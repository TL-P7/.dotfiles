local function open_path()
  local paths = {
    "1. /home/tlp/.dotfile/.config/nvim/",
    "2. /home/tlp/Documents/code/cp/",
    "3. /home/tlp/Documents/code/notes/",
  }
  vim.ui.select(paths, {
      format_items = function(items)
        return "I would like to choose" .. items
      end
    },
    function(choice)
      print(choice)
    end
  )

--  local index = vim.fn.inputlist(paths)

--  if index > 0 and index <= #paths then
--    print("NvimTreeOpen " .. string.sub(paths[index], 4, string.len(paths[index])))
--    vim.cmd("NvimTreeOpen " .. string.sub(paths[index], 4, string.len(paths[index])))
--  else
--    print("Invalid selection")
--  end
end

vim.keymap.set("n", "<leader>mb", open_path, { silent = true, noremap = true })
