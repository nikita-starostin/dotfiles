function vim.getVisualSelection()
  vim.cmd('noau normal! "vy"')
  local text = vim.fn.getreg('v')
  vim.fn.setreg('v', {})

  text = string.gsub(text, "\n", "")
  if #text > 0 then
    return text
  else
    return ''
  end
end

local builtin = require('telescope.builtin')
local utils = require('telescope.utils')

-- search in the directory, where current buffer is opened
vim.keymap.set('n', '<leader>lld', function()
  builtin.find_files({ cwd = utils.buffer_dir() })
end, { desc = 'look files in current buffer dir' })

vim.keymap.set('n', '<leader>w', builtin.find_files, { desc = 'look files in project dir' })
vim.keymap.set('n', '<leader>lb', builtin.buffers, { desc = 'look opened buffers' })
vim.keymap.set('n', '<leader>lr', builtin.resume, { desc = 'resume last look' })
vim.keymap.set('n', '<leader>lh', builtin.search_history, { desc = 'look in search history' })
vim.keymap.set('n', '<leader>lc', builtin.command_history, { desc = 'look in command history' })
vim.keymap.set('n', '<leader>lj', builtin.jumplist, { desc = 'look in jumplist' })
vim.keymap.set('n', '<leader>lk', builtin.keymaps, { desc = 'look in keymaps' })
vim.keymap.set('n', '<leader>la', builtin.commands, { desc = 'look actions' })

-- greps
vim.keymap.set('n', '<leader>lg', builtin.live_grep, { desc = 'look for a text in nvim directory' })
vim.keymap.set('n', '<leader>ls', builtin.grep_string, { desc = 'look for a text in nvim directory' })
vim.keymap.set('v', '<leader>lg', function()
  local text = vim.getVisualSelection()
  builtin.live_grep({ default_text = text })
end, { desc = 'look for a text in nvim directory' })
vim.keymap.set('v', '<leader>ls', function()
  local text = vim.getVisualSelection()
  builtin.grep_string({ search = text })
end, { desc = 'look for a static text in nvim directory' })

-- check for commands and available telescope pickers
vim.keymap.set('n', '<C-a>', builtin.commands, {})
vim.keymap.set('n', '<C-z>', builtin.builtin, {})
