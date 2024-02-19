-- nice themes
-- zellner light theme
-- slate default for now
-- habamax light theme, should be nice for long coding
-- evening may be nice for light days
-- 'PaperColor' installed
-- cattpuccin installed
-- blue, lightblue - two theme close to turbo pascal
function SetMyTheme(color)
	color = color or "slate"
	vim.cmd.colorscheme(color)
	-- make the nvim itself 0 opacity, the terminal would be used as background
	-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

return {
	{
		"NLKNguyen/papercolor-theme",
		name = "papercolor",
		priority = 1000,
		config = function ()
			SetMyTheme()
		end
	},
	{
		"catppuccin/nvim",
		name = "catppuccin",
		priority = 990
	}
}
