local actions = require('telescope.actions')
require('telescope').setup {
	defaults = {
		mappings = {
			i = {
				["<C-j>"] = {
					actions.move_selection_next, type = "action",
					opts = { nowait = true, silent = true }
				},
				["<C-k>"] = {
					actions.move_selection_previous, type = "action",
					opts = { nowait = true, silent = true }
				},
			}
		}
	}
}

local builtin = require('telescope.builtin')
local utils = require('telescope.utils')
vim.keymap.set('n', '<leader>ff', function()
	builtin.find_files({ cwd = utils.buffer_dir() })
end)
vim.keymap.set('n', '<leader>pf', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>ps', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<C-a>', builtin.commands, {})
vim.keymap.set('n', '<C-q>', builtin.builtin, {})
vim.keymap.set('n', '<C-z>', builtin.grep_string, {})

vim.keymap.set('n', '<leader>gc', builtin.git_commits, {})
vim.keymap.set('n', '<leader>gh', builtin.git_bcommits, {})
vim.keymap.set('n', '<leader>gb', builtin.git_branches, {})
vim.keymap.set('n', '<leader>gs', builtin.git_status, {})

