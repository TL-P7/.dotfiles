return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority = 1000,
    build = ":TSUpdate",
    config = function()
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
          "c",
          "cpp",
          "bash",
          "go",
          "lua",
          "vim",
          "python",
          "json"
        },
        auto_install = true,
        highlight = {
          enable = true,
          disable = {}, -- list of language that will be disabled
        },
        indent = {
          enable = true
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection    = "<CR>",
            node_incremental  = "<CR>",
            node_decremental  = "<BS>",
            scope_incremental = "<TAB>",
          },
        }
      })
    end
  },

  {
    "VonHeikemen/lsp-zero.nvim",
    lazy = false,
    branch = "v2.x",
    dependencies = {
      {
        "williamboman/mason-lspconfig.nvim",
        dependencies = {
          { "williamboman/mason.nvim", build = ":MasonUpdate", },
        },
        config = function()
          require("mason").setup({
            ui = {
              icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
              }
            }
          })
          require("mason-lspconfig").setup({
            ensure_installed = {
              "lua_ls",
              "clangd",
              "bashls",
              "pyright",
            },
            automatic_installation = true,
          })
        end
      },

      {
        "neovim/nvim-lspconfig",
        lazy = false,
        config = function()
          require("neodev").setup({})
          local lspconfig = require("lspconfig")
          lspconfig['lua_ls'].setup({
            settings = {
              Lua = {
                completion = {
                  callSnippet = "Replace"
                }
              }
            }
          })
          lspconfig['clangd'].setup({})
          lspconfig['bashls'].setup({
            enableSourceErrorDiagnostics = true,
          })
          lspconfig['pyright'].setup({})
          lspconfig['html'].setup({})
          lspconfig['kotlin_language_server'].setup({})

          vim.api.nvim_create_autocmd('LspAttach', {
            desc = 'LSP actions',
            callback = function(event)
              local opts = { buffer = event.buf, noremap = true, nowait = true }
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', 'gR', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, "<M-CR>", vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
              vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
              vim.keymap.set("n", "<leader>sn", vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set({ 'n', 'x' }, '<C-f>', function() vim.lsp.buf.format({ async = true }) end, opts)
            end
          })
        end,
      }
    },
    config = function()
      local lsp = require("lsp-zero").preset({})
      lsp.on_attach(function(client, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)
      lsp.setup()
    end,
  },
  {
    "folke/neodev.nvim",
    lazy = false,
    config = function()
      require("neodev").setup({
        library = { plugins = { "nvim-dap-ui" }, types = true },
      })
    end
  },
  {
    "folke/trouble.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    opts = {
      position = "right",
      use_diagnostic_signs = true,
    },
  }
}
