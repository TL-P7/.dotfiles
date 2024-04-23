return {
  {
    "lewis6991/gitsigns.nvim",
    lazy = "BufEnter",
    config = function ()
      require("gitsigns").setup()
    end
  }
}
