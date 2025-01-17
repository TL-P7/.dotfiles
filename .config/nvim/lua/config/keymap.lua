vim.g.mapleader = " "
local silent = { noremap = true, silent = true }
local builtin = require("telescope.builtin")
local dap = require("dap")
local mappings = {

  -- disable new buffer by <CR>
  { mode = "n", from = "<CR>",  to = "<Nop>" },

  -- settings for copy and paste
  { mode = "n", from = "<C-e>", to = "<Esc>ggVG" },
  { mode = "v", from = "<C-y>", to = '"+y' },
  { mode = "i", from = "<C-p>", to = '<Esc>"+pa' },
  { mode = "n", from = "<C-p>", to = '"+p' },


  -- exchange two lines
  {
    mode = "n",
    from = "<C-S-k>",
    to = function()
      if vim.fn.line('.') ~= 1 then
        vim.cmd.norm("kddpk")
      end
    end
  },
  {
    mode = "n",
    from = "<C-S-j>",
    to = function()
      local current_line = vim.fn.line('.')
      if current_line == vim.fn.line('$') - 1 then
        vim.cmd.norm("ddp")
      elseif current_line ~= vim.fn.line('$') then
        vim.cmd.norm("jddkPj")
      end
    end
  },

  -- commenting
  { mode = "n", from = "<C-/>",      to = function() vim.cmd.norm("gc$") end },
  { mode = "v", from = "<C-/>",      to = function() vim.cmd.norm("gc") end },

  -- nohl
  { mode = "n", from = "<Esc>u",     to = "<Cmd>nohlsearch<CR>",                  opt = silent },

  -- save file
  { mode = "n", from = "<C-s>",      to = "<Cmd>w<CR>",                           opt = silent },

  -- settings for buliding new tabes and splits
  { mode = "n", from = "<C-m>",      to = "<Cmd>tabe<CR>",                        opt = silent },
  { mode = "n", from = "<C-h>",      to = "<Cmd>BufferLineCyclePrev<CR>",         opt = silent },
  { mode = "n", from = "<C-l>",      to = "<Cmd>BufferLineCycleNext<CR>",         opt = silent },
  { mode = "n", from = "<C-q>",      to = "<Cmd>Bdelete<CR>",                     opt = silent },
  { mode = "n", from = "<leader>q",  to = "<Cmd>Bdelete<CR>:q<CR>",               opt = silent },
  { mode = "n", from = "<M-q>",      to = "<Cmd>q<CR>",                           opt = silent },
  { mode = "n", from = "<leader>sr", to = "<Cmd>set splitright<CR>:vsplit<CR>",   opt = silent },
  { mode = "n", from = "<leader>sl", to = "<Cmd>set nosplitright<CR>:vsplit<CR>", opt = silent },
  { mode = "n", from = "<leader>su", to = "<Cmd>set nosplitbelow<CR>:split<CR>",  opt = silent },
  { mode = "n", from = "<leader>sd", to = "<Cmd>set splitbelow<CR>:split<CR>",    opt = silent },

  -- resize splits
  { mode = "",  from = "<up>",       to = "<Cmd>res +2<CR>",                      opt = silent },
  { mode = "",  from = "<down>",     to = "<Cmd>res -2<CR>",                      opt = silent },
  { mode = "",  from = "<left>",     to = "<Cmd>vertical resize -2<CR>",          opt = silent },
  { mode = "",  from = "<right>",    to = "<Cmd>vertical resize +2<CR>",          opt = silent },
  { mode = "n", from = "<leader>mg", to = function() require('telescope').extensions.lazygit.lazygit() end, opt = { desc = "lazygit" } },
  { mode = "n", from = "<leader>gg", to = "<Cmd>LazyGit<CR>",                                               opt = { desc = "lazygit" } },

  --CompetiTest
  { mode = "n", from = "<leader>rt", to = "<Cmd>CompetiTest run<CR>" },
  { mode = "n", from = "<leader>ta", to = "<Cmd>CompetiTest add_testcase<CR>" },
  { mode = "n", from = "<leader>te", to = "<Cmd>CompetiTest edit_testcase<CR>" },
  { mode = "n", from = "<leader>tr", to = "<Cmd>CompetiTest receive testcases<CR>" },
  { mode = "n", from = "<leader>st", to = "<Cmd>CompetiTest show_ui<CR>" },
  { mode = "n", from = "<leader>td", to = "<Cmd>CompetiTest delete_testcase<CR>" },

  --Dashboard
  { mode = "n", from = "<leader>bd", to = "<Cmd>Dashboard<CR>" },

  --telescope
  { mode = "n", from = "<leader>ff", to = builtin.find_files,                                               opt = { desc = "telescope find files" } },
  { mode = "n", from = "<leader>fc", to = builtin.current_buffer_fuzzy_find,                                opt = { desc = "telescope find current buffer" } },
  { mode = "n", from = "<leader>fg", to = builtin.live_grep,                                                opt = { desc = "telescope find live grep" } },
  { mode = "n", from = "<leader>gs", to = builtin.git_status,                                               opt = { desc = "telescope git status" } },
  { mode = "n", from = "<leader>fb", to = builtin.buffers,                                                  opt = { desc = "telescope find buffers" } },
  { mode = "n", from = "<leader>fh", to = builtin.help_tags,                                                opt = { desc = "telescope find help" } },
  { mode = "n", from = "<leader>fk", to = builtin.keymaps,                                                  opt = { desc = "telescope find keymaps" } },
  { mode = "n", from = "<leader>ss", to = builtin.spell_suggest,                                            opt = { desc = "telescope spell suggest" } },

  --nvim-dap
  { mode = "n", from = "<F5>",       to = function() dap.continue() end },
  { mode = "n", from = "<F6>",       to = function() dap.step_over() end },
  { mode = "n", from = "<S-F6>",     to = function() dap.step_into() end },
  { mode = "n", from = "<F7>",       to = function() dap.step_out() end },
  {
    mode = "n",
    from = "<Leader>db",
    to = function() dap.toggle_breakpoint() end,
    opt = { desc = "dap toggle breakpoint" }
  },
  {
    mode = "n",
    from = "<Leader>dr",
    to = function() dap.repl.opn() end,
    opt = { desc = "dap open repl" }
  },
  { mode = "n", from = "<Leader>dc", to = function() dap.disconnect() end, opt = { desc = "dap disconnect" } },
  { mode = "n", from = "<Leader>dl", to = function() dap.run_last() end,   opt = { desc = "dap run last" } },

  {
    mode = { "n", "v" },
    from = "<Leader>dh",
    to = function()
      require("dap.ui.widgets").hover()
    end,
    opt = { desc = "dap hover" }
  },
  {
    mode = { "n", "v" },
    from = "<Leader>dp",
    to = function()
      require("dap.ui.widgets").preview()
    end,
    opt = { desc = "dap preview" }
  },
  {
    mode = "n",
    from = "<Leader>df",
    to = function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.frames)
    end,
    opt = { desc = "dap frames" }
  },
  {
    mode = "n",
    from = "<Leader>ds",
    to = function()
      local widgets = require("dap.ui.widgets")
      widgets.centered_float(widgets.scopes)
    end,
    opt = { desc = "dap scopes" }
  },
  { mode = "n", from = "<leader>xx", to = function() require("trouble").toggle() end,                        opt = { desc = "trouble toggle" } },

  { mode = "n", from = "<leader>xw", to = function() require("trouble").toggle("workspace_diagnostics") end, opt = { desc = "trouble toggle workspace diagnostics" } },

  { mode = "n", from = "<leader>xd", to = function() require("trouble").toggle("document_diagnostics") end,  opt = { desc = "trouble toggle document diagnostics" } },



  -- trouble
  {
    mode = "n",
    from = "<leader>xq",
    to = function() require("trouble").toggle("quickfix") end,
    opt = { desc = "trouble toggle quickfix" }
  },

  {
    mode = "n",
    from = "<leader>xl",
    to = function() require("trouble").toggle("loclist") end,
    opt = { desc = "trouble toggle loclist" }
  },

  {
    mode = "n",
    from = "gr",
    to = function() require("trouble").toggle("lsp_references") end,
    opt = { desc = "trouble lsp reference" }
  },
}

for _, mapping in ipairs(mappings) do
  vim.keymap.set(mapping.mode or "n", mapping.from, mapping.to, mapping.opt or { noremap = true })
end
