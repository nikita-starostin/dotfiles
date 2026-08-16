-- toggle oil (floating window)
local toggle_oil = function()
  require("oil").toggle_float()
end

vim.keymap.set('n', '<leader>to', toggle_oil, { desc = "Toggle oil (float)" })
vim.keymap.set('n', '<leader>q', toggle_oil, { desc = "Toggle oil (float)" })
-- open oil as a regular editable buffer for longer batch sessions
vim.keymap.set('n', '<leader>Q', function()
  require("oil").open()
end, { desc = "Open oil (buffer)" })
