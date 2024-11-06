return {
  {
    'nvim-treesitter/nvim-treesitter',
    lazy = false,
    priority = 1000,
    build = ':TSUpdate',
    config = function()
      require('nvim-treesitter.configs').setup({
        ensure_installed = {
          'c',
          'cpp',
          'bash',
          'go',
          'lua',
          'vim',
          'python',
          'json'
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
            init_selection    = '<CR>',
            node_incremental  = '<CR>',
            node_decremental  = '<BS>',
            scope_incremental = '<TAB>',
          },
        }
      })
    end
  },

  {
    'VonHeikemen/lsp-zero.nvim',
    lazy = false,
    branch = 'v3.x',
    dependencies = {
      {
        'williamboman/mason-lspconfig.nvim',
        dependencies = {
          { 'williamboman/mason.nvim', build = ':MasonUpdate', },
        },
        config = function()
          require('mason').setup({
            ui = {
              icons = {
                package_installed = '✓',
                package_pending = '➜',
                package_uninstalled = '✗'
              }
            }
          })
          require('mason-lspconfig').setup({
            ensure_installed = {
              'lua_ls',
              'clangd',
              'bashls',
              'pyright',
            },
            automatic_installation = true,
          })
        end
      },

      {
        'neovim/nvim-lspconfig',
        lazy = false,
        config = function()
          require('lsp-zero').extend_lspconfig()
          require('neodev').setup()
          local lspconfig = require('lspconfig')
          lspconfig['lua_ls'].setup({
            settings = {
              Lua = {
                hint = {
                  enable = true,
                },
                completion = {
                  callSnippet = 'Replace'
                }
              }
            }
          })
          lspconfig['clangd'].setup({
            cmd = { 'clangd', '--clang-tidy', '--background-index', '--all-scopes-completion' },
            settings = {
              clangd = {
                InlayHints = {
                  Designators = true,
                  Enabled = true,
                  ParameterNames = true,
                  DeducedTypes = true,
                },
                fallbackFlags = { "-std=c++20" },
              },
            }
          })
          lspconfig['ts_ls'].setup({})
          lspconfig['bashls'].setup({
            enableSourceErrorDiagnostics = true,
          })
          lspconfig['pyright'].setup({
            settings = {
              python = {
                analysis = {
                  inlayHints = {
                    variableTypes = true,       -- 显示变量类型的 inlay hints
                    functionReturnTypes = true, -- 显示函数返回类型的 inlay hints
                  },
                },
              },
            }
          })
          lspconfig['html'].setup({})
          lspconfig['kotlin_language_server'].setup({
            cmd = { 'kotlin-language-server' },
            filetypes = { 'kotlin' },
            root_dir = function(fname)
              return lspconfig.util.root_pattern('settings.gradle.kts', 'build.gradle.kts', 'pom.xml')(fname) or
                  lspconfig.util.find_git_ancestor(fname) or lspconfig.util.path.dirname(fname)
            end
          })
          lspconfig['markdown_oxide'].setup({})
          lspconfig['tinymist'].setup({
            single_file_support = true,
            on_attach = function(client)
              client.server_capabilities.semanticTokensProvider = nil
            end,
          })

          vim.keymap.set("n", "<leader>th", function()
            vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled(), nil)
          end, { desc = "Toggle inlay hints" })

          vim.api.nvim_create_autocmd('BufEnter', {
            desc = 'LSP actions',
            callback = function(event)
              local opts = { buffer = event.buf, noremap = true, nowait = true }
              vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
              vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
              vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
              vim.keymap.set('n', 'gy', vim.lsp.buf.type_definition, opts)
              vim.keymap.set('n', 'gR', vim.lsp.buf.references, opts)
              vim.keymap.set('n', '<leader>rn', vim.lsp.buf.rename, opts)
              vim.keymap.set({ 'n', 'v' }, '<M-CR>', vim.lsp.buf.code_action, opts)
              vim.keymap.set('n', '[g', vim.diagnostic.goto_prev, opts)
              vim.keymap.set('n', ']g', vim.diagnostic.goto_next, opts)
              vim.keymap.set('n', '<leader>sn', vim.lsp.buf.signature_help, opts)
              vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
              vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
              vim.keymap.set('n', '<space>wl', function()
                print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
              end, opts)
              vim.keymap.set({ 'n', 'x' }, '<C-f>', '<Cmd>Guard fmt<CR>', opts)
            end
          })
        end,
      }
    },
    config = function()
      local lsp = require('lsp-zero')
      lsp.on_attach(function(_, bufnr)
        lsp.default_keymaps({ buffer = bufnr })
      end)
      lsp.setup()
    end,
  },
  {
    'folke/neodev.nvim',
    lazy = false,
    config = function()
      require('neodev').setup({
        library = { plugins = { 'nvim-dap-ui' }, types = true },
      })
    end
  },
  {
    'folke/trouble.nvim',
    dependencies = { 'nvim-tree/nvim-web-devicons' },
    opts = {
      position = 'right',
      use_diagnostic_signs = true,
    },
  },
  {
    'nvimdev/guard.nvim',
    config = function()
      local ft = require('guard.filetype')
      ft('c'):fmt('clang-format')
      ft('sh'):fmt({
        cmd = 'shfmt',
        args = { '-i', '4' },
      })
      ft('python'):fmt('black')
      ft('javascript,json,markdown'):fmt('prettier')
      -- ft('typst'):fmt('typstfmt')
      -- ft('*'):lint('codespell')

      vim.g.guard_config = {
        fmt_on_save = false,
        lsp_as_default_formatter = true,
        save_on_format = true
      }
    end,
    -- Builtin configuration, optional
    dependencies = {
      'nvimdev/guard-collection',
      'VonHeikemen/lsp-zero.nvim'
    },
  },
}
