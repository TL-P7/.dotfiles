--basic settings
vim.g.mapleader = ' '
vim.o.termguicolors = true
vim.o.syntax = "enable"
vim.o.number = true
vim.o.relativenumber = true
vim.o.expandtab = true
vim.o.showcmd = true
vim.o.cursorline = false
vim.o.autochdir = true
vim.o.swapfile = false
vim.o.wrap = true
vim.o.wildmenu = true
vim.o.compatible = false
vim.o.encoding = 'utf-8'

--help
vim.o.helpheight = 999999999

--mouse
vim.o.mouse = 'a'

--disable netrw
-- vim.g.loaded_netrw = 1
-- vim.g.loaded_netrwPlugin = 1

--undo history
vim.o.undodir = "/home/tlp/.nvimundohistory"
vim.o.undofile = true

--TODO
vim.cmd([[

filetype on
filetype indent on
filetype plugin on
filetype plugin indent on

]])


--setting for indent
vim.o.smartindent = true
vim.o.autoindent = true

vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWinEnter' }, {
  callback = function()
    local ft = vim.bo.filetype
    if ft == 'c' or ft == 'cpp' or ft == 'h' or ft == 'go' or ft == 'rust' or ft == 'sh' then
      vim.o.cindent = true
      vim.o.tabstop = 4
      vim.o.softtabstop = 4
      vim.o.shiftwidth = 4
    elseif ft == 'lua' or ft == 'vim' or ft == 'javascript' then
      vim.o.tabstop = 2
      vim.o.softtabstop = 2
      vim.o.shiftwidth = 2
    else
      vim.o.tabstop = 4
      vim.o.softtabstop = 4
      vim.o.shiftwidth = 4
    end
  end
})


vim.o.list = true
vim.opt.listchars = { tab = '->', trail = '-' }
vim.o.scrolloff = 5
vim.opt.backspace = { "indent", "eol", "start" }
vim.o.foldmethod = "indent"
vim.o.foldlevel = 99
vim.o.laststatus = 2


--settings for search
vim.o.hlsearch = true
vim.o.incsearch = true

--settings for cursor
vim.cmd([[
" cursor shape when entering Insert Mode
let &t_SI.="\e[5 q"

" cursor shape when entering Replace Mode
let &t_SR.="\e[3 q"

" cursor shape when entering Normal Mode
let &t_EI.="\e[1 q"

let t_ut=''

]])

--local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶", Info = " " }
local signs = { Error = "❌", Warn = "🆖", Hint = "💡", Info = "✅️" }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end
