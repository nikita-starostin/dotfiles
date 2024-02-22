vim.g.mapleader = " "
vim.g.guicursor = "n-v-c-i:block"
vim.opt.number = true
vim.opt.relativenumber = true

local tabSize = 2
vim.opt.tabstop = tabSize
vim.opt.softtabstop = tabSize
vim.opt.shiftwidth = tabSize
vim.opt.smartindent = true
vim.opt.expandtab = true -- use spaces instead of tabs
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

vim.opt.colorcolumn = "9999"   -- remove ident line
vim.opt.conceallevel = 0       -- show markdown as it is
vim.opt.cursorline = false     -- don't highlight the current line
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.showmode = false       -- hide things like -- INSERT
vim.opt.showtabline = 1        -- show tabs if more then one
vim.opt.laststatus = 2         -- always show status

-- code folding
vim.opt.foldmethod = "expr"
vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
vim.opt.foldlevel = 99
