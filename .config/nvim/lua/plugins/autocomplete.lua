local has_words_before = function()
  unpack = unpack or table.unpack
  local line, col = unpack(vim.api.nvim_win_get_cursor(0))
  return col ~= 0
      and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
end
return {
  {
    "hrsh7th/nvim-cmp",
    event = "VeryLazy",
    dependencies = {
      "hrsh7th/cmp-cmdline",
      "hrsh7th/cmp-buffer",
      "hrsh7th/cmp-path",
      "hrsh7th/cmp-nvim-lsp",
      "hrsh7th/cmp-nvim-lua",
      {
        "onsails/lspkind.nvim",
        lazy = false,
        config = function()
          require("lspkind").init()
        end
      },
      {
        "L3MON4D3/LuaSnip",
        config = function()
          require("luasnip").config.set_config({
            enable_autosnippets = true,
            store_selection_keys = ";",
          })
          require("luasnip.loaders.from_lua").load({ paths = { "~/.config/nvim/snippets" } })
          local auto_expand = require("luasnip").expand_auto
          require("luasnip").expand_auto = function(...)
            vim.o.undolevels = vim.o.undolevels
            auto_expand(...)
          end

          local ls = require("luasnip")
          vim.keymap.set({ "i", "s" }, "<C-,>", function()
            if ls.choice_active() then
              ls.change_choice(1)
            end
          end)
          vim.keymap.set({ "i", "s" }, "<C-.>", function()
            if ls.choice_active() then
              ls.change_choice(-1)
            end
          end)
        end

      },
      "saadparwaiz1/cmp_luasnip",
      {
        "rafamadriz/friendly-snippets"
      },
      {
        "zbirenbaum/copilot-cmp",
        config = function()
          require("copilot_cmp").setup({
            event = { "InsertEnter", "LspAttach" },
            fix_pairs = true,
          })
        end
      },
    },

    config = function()
      local luasnip = require("luasnip")
      local cmp = require("cmp")
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      local lspkind = require("lspkind")
      -- require("luasnip.loaders.from_snipmate").lazy_load({ { path = "~/.config/nvim/snippets" } })
      require("luasnip.loaders.from_vscode").lazy_load()
      cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      cmp.setup({
        snippet = {
          expand = function(args)
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = cmp.mapping.preset.insert({
          ["<TAB>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(1) then
              luasnip.jump(1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<S-TAB>"] = cmp.mapping(function(fallback)
            if luasnip.jumpable(-1) then
              luasnip.jump(-1)
            else
              fallback()
            end
          end, { "i", "s" }),
          ["<C-n>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_next_item()
            elseif has_words_before() then
              cmp.complete()
            end
          end, { "i", "s" }),

          ["<C-p>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            end
          end, { "i", "s" }),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false
          }),                  -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
          ["<C-j>"] = cmp.mapping.scroll_docs(4),
          ["<C-k>"] = cmp.mapping.scroll_docs(-4),
          ["<C-q>"] = cmp.mapping.close()
        }),

        --mapping = {
        --["<CR>"] = cmp.mapping.confirm({
        --behavior = cmp.ConfirmBehavior.Replace,
        --select = true
        --}),
        --["<C-Space>"] = cmp.mapping.complete(),
        --["<C-j>"] = cmp.mapping.scroll_docs(4),
        --["<S-TAB>"] = cmp.mapping.select_prev_item(),
        --["<TAB>"] = cmp.mapping.select_next_item(),
        --["<C-k>"] = cmp.mapping.scroll_docs(-4),
        --["<C-c>"] = cmp.mapping.close()
        --},

        window = {
          completion = cmp.config.window.bordered(),
          documentation = cmp.config.window.bordered(),
        },
        sources = cmp.config.sources(
          {
            { name = "nvim_lsp" },
            { name = "nvim_lua" },
            { name = "luasnip" },
            { name = "copilot" },
            { name = "buffer" },
            { name = "path" },
          }
        ),

        formatting = {
          format = lspkind.cmp_format({
            mode = "symbol_text",
            menu = ({
              buffer = "[Buffer]",
              nvim_lsp = "[LSP]",
              luasnip = "[LuaSnip]",
              nvim_lua = "[Lua]",
              latex_symbols = "[Latex]",
              copilot = "[Copilot]"
            })
          }),
        },
      })


      --git
      cmp.setup.filetype("gitcommit", {
        sources = cmp.config.sources({
          { name = "buffer" },
        }),
      })

      cmp.setup.cmdline(":", {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
          { name = "path" },
        }, {
          { name = "cmdline" },
        }),
      })

      cmp.setup.cmdline({ '/', '?' }, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
          { name = 'buffer' }
        }
      })
    end,
  },
}
