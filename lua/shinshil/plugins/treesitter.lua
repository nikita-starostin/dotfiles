return {
	"nvim-treesitter/nvim-treesitter",
	config = function () 
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
				build = ":TSUpdated"
			})
	end
}
