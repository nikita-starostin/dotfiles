return {
	"nvim-treesitter/nvim-treesitter",
	config = function () 
		require "nvim-treesitter.install".compilers = { "clang" }

		local configs = require("nvim-treesitter.configs")

		configs.setup({
				ensure_installed = {
					"lua", 
					"vim",
					"vimdoc",
					"html",
					"query"
				},
				sync_install = false,
				auto_install = false,
				highlight = { enable = true },
				indent = { enable = true },  
				build = ":TSUpdate"
			})
	end
}
