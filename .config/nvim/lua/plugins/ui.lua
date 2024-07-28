return {
  {
    --dashboard
    "nvimdev/dashboard-nvim",
    event = "VimEnter",
    config = function()
      -- ANSI shadow
      local logo = [[
███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
      ]]
      logo = "\n\n" .. logo .. "\n"
      require("dashboard").setup {
        --theme = 'doom',
        --config = {
        --header = vim.split(logo, "\n"),
        --center = {
        --{
        --icon = ' ',
        --icon_hl = 'Title',
        --desc = 'Find File           ',
        --desc_hl = 'String',
        --key = 'b',
        --keymap = 'SPC f f',
        --key_hl = 'Number',
        --key_format = ' %s', -- remove default surrounding `[]`
        --action = 'lua print(2)'
        --},
        --{
        --icon = ' ',
        --desc = 'Find Dotfiles',
        --key = 'f',
        --keymap = 'SPC f d',
        --key_format = ' %s', -- remove default surrounding `[]`
        --action = 'lua print(3)'
        --},
        --},
        --footer = {} --your footer
        --},
        theme = "hyper",
        config = {
          header = vim.split(logo, "\n"),
          week_header = {
            enable = false,
          },
          shortcut = {
            { desc = "󰊳 Update", group = "@property", action = "Lazy update", key = "u" },
            {
              icon = " ",
              icon_hl = "@variable",
              desc = "Files",
              group = "Label",
              action = "Telescope find_files",
              key = "f",
            },
            {
              desc = " Mason",
              group = "DiagnosticHint",
              action = "MasonUpdate",
              key = "m",
            },
            {
              desc = " dotfiles",
              group = "Number",
              action = "lua require('telescope.builtin').find_files({ cwd = vim.fn.getenv('HOME') .. '/.dotfiles', hidden = true })",
              key = "d",
            },
          },
          footer = { "What is mind? No matter. What is matter? Never mind." },
        },
      }
    end,
    dependencies = { { "nvim-tree/nvim-web-devicons" } }
  },
  --lualine
  {
    "nvim-lualine/lualine.nvim",
    event = "BufEnter",
    dependencies = "nvim-tree/nvim-web-devicons",
    config = function()
      require("lualine").setup {
        options = {
          theme = "tokyonight"
        },
      }
    end
  },
  --bufferline
  {
    "akinsho/bufferline.nvim",
    event = "BufEnter",
    -- version = "*",
    branch = "main",
    dependencies = { "nvim-tree/nvim-web-devicons", "moll/vim-bbye" },
    config = function()
      require("bufferline").setup {
        options = {
          theme = "tokyonight",
          --mode = "tabs",
          diagnostics = "nvim_lsp",
          offsets = {
            {
              --TODO
              filetype = "NvimTree",
              text = "File Explorer",
              highlight = "Directory",
              text_align = "left"
            },
            show_buffer_close_icons = true,
            show_close_icon = false,
            enforce_regular_tabs = true,
            tab_size = 16,
            padding = 0,
            separator_style = "thick",
          }
        }
      }
    end,
  },
  {
    "folke/noice.nvim",
    event = "VeryLazy",
    config = {
      lsp = {
        override = {
          ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
          ["vim.lsp.util.stylize_markdown"] = true,
          ["cmp.entry.get_documentation"] = true,
        },
      },
      presets = {
        bottom_search = true,
        long_message_to_split = true,
        inc_rename = false,
        lsp_doc_border = false,
      },
    },
    opts = {
      cmdline = {
      }
      -- add any options here
    },
    dependencies = {
      -- if you lazy-load any plugin below, make sure to add proper `module="..."` entries
      "MunifTanjim/nui.nvim",
      -- OPTIONAL:
      --   `nvim-notify` is only needed, if you want to use the notification view.
      --   If not available, we use `mini` as the fallback
      "rcarriga/nvim-notify",
    }
  },
  {
    "utilyre/barbecue.nvim",
    name = "barbecue",
    version = "*",
    dependencies = {
      "SmiteshP/nvim-navic",
      "nvim-tree/nvim-web-devicons", -- optional dependency
    },
    config = function()
      -- Lua
      require('barbecue').setup({
        -- ... your barbecue config
        theme = 'tokyonight',
      })
    end
  },
}
