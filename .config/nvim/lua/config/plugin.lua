--initialize lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable", -- latest stable release
    lazypath,
  })
end

vim.opt.rtp:prepend(lazypath)

require("lazy").setup({
  require("plugins.lsp"),
  require("plugins.autocomplete"),
  require("plugins.copilot"),
  require("plugins.ui"),
  require("plugins.visual-multi"),
  require("plugins.color"),
  require("plugins.competitest"),
  require("plugins.filebrowser"),
  require("plugins.editor"),
  require("plugins.markdown"),
  require("plugins.debug"),
  require("plugins.git"),
  require("plugins.undo"),
  require("plugins.translator"),
  require("plugins.telescope"),
  require("plugins.which-key"),
  require("plugins.typst"),
  require("plugins.test")
})

require("my_plugins.compile_run")
require("my_plugins.bookmark")
