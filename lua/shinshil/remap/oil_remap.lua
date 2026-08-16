-- toggle oil
local toggle_oil = function()
  vim.cmd((vim.bo.filetype == 'oil') and 'bd' or 'Oil')
end

vim.keymap.set('n', '<leader>to', toggle_oil, { desc = "Toggle oil" })
vim.keymap.set('n', '<leader>q', toggle_oil, { desc = "Toggle oil" })
