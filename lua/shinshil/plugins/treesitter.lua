return {
	"nvim-treesitter/nvim-treesitter",
	config = function ()
		require "nvim-treesitter.install".compilers = { "clang", "gcc" }

		local configs = require("nvim-treesitter.configs")

		configs.setup({
				ensure_installed = {
					"lua",
					"vim",
					"vimdoc",
					"html",
					"query",
					"typescript",
					"javascript",
					"bicep",
					"c_sharp",
					"css",
					"lua"
				},
				sync_install = false,
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },
				build = ":TSUpdate"
			})
	end
}
