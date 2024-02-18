local telescopeActions = require('telescope.actions')
local telescope = require('telescope')
local telescopeConfig = require("telescope.config")

-- Clone the default Telescope configuration
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }

-- I want to search in hidden/dot files.
table.insert(vimgrep_arguments, "--hidden")
-- I don't want to search in the `.git` directory.
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

telescope.setup {
	defaults = {
		vimgrep_arguments = vimgrep_arguments,
		mappings = {
			i = {
				["<esc>"] = telescopeActions.close,
				["<C-u>"] = false,
				["<C-j>"] = {
					telescopeActions.move_selection_next, type = "action",
					opts = { nowait = true, silent = true }
				},
				["<C-k>"] = {
					telescopeActions.move_selection_previous, type = "action",
					opts = { nowait = true, silent = true }
				},
			}
		}
	},
	pickers = {
		find_files = {
			-- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
			find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
		},
	},
}

local builtin = require('telescope.builtin')
local utils = require('telescope.utils')
vim.keymap.set('n', '<leader>ff', function()
	builtin.find_files({ cwd = utils.buffer_dir() })
end)
vim.keymap.set('n', '<S-w>', builtin.find_files, {})
vim.keymap.set('n', '<C-p>', builtin.git_files, {})
vim.keymap.set('n', '<leader>s', function()
	builtin.grep_string({ search = vim.fn.input("Grep > ") });
end)

vim.keymap.set('n', '<C-a>', builtin.commands, {})
vim.keymap.set('n', '<C-q>', builtin.builtin, {})
-- search word under cursor across files
vim.keymap.set('n', '<C-z>', builtin.grep_string, {})
