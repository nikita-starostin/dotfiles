-- autosave on changes
local saveGroup = vim.api.nvim_create_augroup("SaveGroup", { clear = true })
vim.api.nvim_create_autocmd(
	{ "WinLeave", "TextChanged", "InsertLeave" },
	{ pattern = "*", command = "update", group = saveGroup }
)

vim.opt.number = true
vim.opt.relativenumber = true

local tabSize = 2
vim.opt.tabstop = tabSize
vim.opt.softtabstop = tabSize
vim.opt.shiftwidth = tabSize
vim.opt.smartindent = true
vim.opt.wrap = false

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"
