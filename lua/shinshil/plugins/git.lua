return {
	-- vim signs inside editor
	{
		"lewis6991/gitsigns.nvim",
	},

	-- integration with lazygit to make commits
	{
		"kdheepak/lazygit.nvim",
		-- optional for floating window border decoration
		dependencies = {
			"nvim-lua/plenary.nvim",
		},
	},
}
