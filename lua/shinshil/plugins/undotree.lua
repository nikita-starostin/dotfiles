return {
    "mbbill/undotree",
    event = { 'BufReadPre', 'BufNewFile' },
    branch = "master",
		config = function ()
			vim.keymap.set('n', '<leader>u', vim.cmd.UndotreeToggle)
		end
}
