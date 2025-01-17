return {
  {
    "lewis6991/gitsigns.nvim",
    event = "BufEnter",
    config = function()
      require("gitsigns").setup()
      vim.keymap.set("n", "]s", "<Cmd>lua require('gitsigns').nav_hunk('next')<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "[s", "<Cmd>lua require('gitsigns').nav_hunk('prev')<CR>", { noremap = true, silent = true })
    end
  }
}
