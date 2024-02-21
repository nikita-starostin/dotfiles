return {
	"okuuva/auto-save.nvim",
	config = function()
		require("auto-save").setup({
			enabled = true,
			condition = function(buf)
				local fn = vim.fn

				-- that is to sync with Harpoon menu
				if fn.getbufvar(buf, "&filetype") == 'harpoon'
				then
					return false
				end
				return true
			end
		});
		vim.api.nvim_set_keymap("n", "<leader>ta", ":ASToggle<CR>", {});
	end
}
