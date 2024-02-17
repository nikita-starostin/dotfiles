function SetMyTheme(color)
	color = color or "catppuccin"
	vim.cmd.colorscheme(color)
	-- make the nvim itself 0 opacity, the terminal would be used as background
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

SetMyTheme()
