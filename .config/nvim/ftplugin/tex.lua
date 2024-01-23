-- F6 closes the viewer application, and allows settings to be reset
vim.keymap.set({ 'n', 'v', 'i' }, '<leader>tc', function() require("knap").close_viewer() end)
-- F7 toggles the auto-processing on and off
vim.keymap.set({ 'n', 'v', 'i' }, '<leader>tp', function() require("knap").toggle_autopreviewing() end)

-- F8 invokes a SyncTeX forward search, or similar, where appropriate
vim.keymap.set({ 'n', 'v', 'i' }, '<leader>tj', function() require("knap").forward_jump() end)
