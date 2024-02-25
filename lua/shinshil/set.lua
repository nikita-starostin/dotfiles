vim.g.mapleader = " "
vim.g.guicursor = "n-v-c-i:block" -- show cursor as square all the time

vim.opt.number = false -- turn off line numbers
vim.opt.relativenumber = false -- turn off relative line numbers

-- identation
local tabSize = 2
vim.opt.tabstop = tabSize -- spaces for tabs
vim.opt.softtabstop = tabSize -- spaces for tabs
vim.opt.shiftwidth = tabSize -- spaces for autoindent
vim.opt.smartindent = true -- autoindent new lines
vim.opt.expandtab = true -- use spaces instead of tabs

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true -- case sensitive if there is a different case letters

vim.opt.swapfile = false
vim.opt.backup = false

-- appearance
vim.opt.hlsearch = false -- don't highlight search results
vim.opt.incsearch = true -- highlight matches search when typing
vim.opt.termguicolors = true -- true color support
vim.opt.scrolloff = 8 -- keep 8 lines when scrolling
vim.opt.signcolumn = "no" -- don't show sign column
vim.opt.isfname:append("@-@") -- allow filenames with @
vim.opt.updatetime = 50 -- update interval for rerendering the screen
vim.opt.colorcolumn = "9999"   -- remove identline
vim.opt.conceallevel = 0       -- show markdown as it is
vim.opt.cursorline = false     -- don't highlight the current line
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.showmode = false       -- hide things like -- INSERT
vim.opt.showtabline = 1        -- show tabs if more then one
vim.opt.laststatus = 2         -- always show status bar

-- code folding
vim.opt.foldmethod = "expr" -- fold based on expression
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter expressions for folding
vim.opt.foldlevel = 99 -- keep everything unfold by default
