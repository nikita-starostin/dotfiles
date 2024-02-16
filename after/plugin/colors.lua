function ColorAll(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
	-- making bg opacity 0
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorAll()
