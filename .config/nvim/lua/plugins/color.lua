return {
  {
    "folke/tokyonight.nvim",
    lazy = false,
    priority = 2000,
    config = function()
      require("tokyonight").setup({
        style = 'moon',
        light_style = 'day',
      })
      vim.cmd([[colorscheme tokyonight-moon]])
      vim.keymap.set("n", "<leader>ct", "<Cmd>colorscheme tokyonight-moon<CR>")
    end,
  },
  {
    "tanvirtin/monokai.nvim",
    config = function()
      vim.keymap.set("n", "<leader>cm", "<Cmd>colorscheme monokai<CR>")
      -- require('monokai').setup { palette = require('monokai').pro }
      -- require('monokai').setup { palette = require('monokai').soda }
      -- require('monokai').setup { palette = require('monokai').ristretto }
    end
  },
  {
    "Enonya/yuyuko.vim",
    config = function()
      vim.keymap.set("n", "<leader>cy", "<Cmd>colorscheme yuyuko<CR>")
    end
  }
}
