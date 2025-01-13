--Compile function
local split = function()
  vim.cmd([[
  set splitbelow
  sp
  res -5
  ]])
end

local compileRun = function()
  local ft = vim.bo.filetype
  vim.cmd("w")
  if ft == "cpp" then
    split()
    vim.cmd("term g++ % -o %< -std=c++20 -lfmt -g -Wall -Wextra -Wpedantic && time ./%<")
  elseif ft == "c" then
    split()
    if vim.fn.filereadable("Makefile") == 1 then
      vim.cmd("term make && ./%")
    else
      vim.cmd("term gcc -std=c99 % -o %< && time ./%<")
    end
  elseif ft == "python" then
    split()
    vim.cmd("term time python3 %")
  elseif ft == "sh" then
    split()
    vim.cmd("term time bash %")
  elseif ft == "markdown" then
    vim.cmd("MarkdownPreview")
  elseif ft == "tex" then
    require("knap").process_once()
  elseif ft == "lua" then
    split()
    vim.cmd("term lua %")
  elseif ft == "go" then
    split()
    vim.cmd("term go run %")
  elseif ft == "kotlin" then
    split()
    vim.cmd("term kotlinc % -include-runtime -d %<.jar && time java -jar %<.jar")
  elseif ft == "html" then
    vim.cmd("silent !firefox % &")
  else
    if ft == "typst" then
      vim.cmd('TypstPreview')
    end
  end
end

vim.keymap.set("n", "<leader>rr", compileRun, { silent = true, noremap = true })
