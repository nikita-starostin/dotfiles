-- toggle oil
vim.keymap.set('n', '<leader>to', function()
  vim.cmd((vim.bo.filetype == 'oil') and 'bd' or 'Oil')
end, { desc = "Toggle oil" })
