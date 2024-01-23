return {
  "simnalamburt/vim-mundo",
  event = "BufEnter",
  config = function()
    vim.keymap.set("n", "<leader>u", "<Cmd>MundoToggle<CR>")
  end
}

