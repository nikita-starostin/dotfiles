return {
	"okuuva/auto-save.nvim",
  event = { 'BufReadPre', 'BufNewFile' },
	config = function()
		require("auto-save").setup({
			enabled = true,
			condition = function(buf)
				local fn = vim.fn

				-- disable autosave for harpoon, or harpoon would be broken
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
