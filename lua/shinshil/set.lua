vim.g.mapleader = " "

-- configure lf
vim.g.lf_map_keys = 0 -- disable default lf keybindings
vim.g.floaterm_opener = 'drop' -- open floaterm in a floating window

-- attemp to show lf by default
-- vim.g.NERDTreeHijackNetrw = 0 -- Add this line if you use NERDTree
-- vim.g.lf_replace_netrw = 0 -- Open lf when vim opens a directory
-- augroup ReplaceNetrwByLfVim
    -- autocmd VimEnter * silent! autocmd! FileExplorer
    -- autocmd BufEnter * let s:buf_path = expand("%") | if isdirectory(s:buf_path) | bdelete! | call timer_start(100, {->OpenLfIn(s:buf_path, s:default_edit_cmd)}) | endif
-- augroup END

vim.opt.number = false         -- turn off line numbers
vim.opt.relativenumber = false -- turn off relative line numbers

-- identation
function SetTabSize(tabSize)
  vim.opt.tabstop = tabSize     -- spaces for tabs
  vim.opt.softtabstop = tabSize -- spaces for tabs
  vim.opt.shiftwidth = tabSize  -- spaces for autoindent
  vim.opt.smartindent = true    -- autoindent new lines
  vim.opt.expandtab = true      -- use spaces instead of tabs
end

SetTabSize(2)

-- line wrapping
vim.opt.wrap = false

-- search settings
vim.opt.ignorecase = true -- case insensitive search
vim.opt.smartcase = true  -- case sensitive if there is a different case letters

-- backup options
vim.opt.swapfile = false          -- don't create swap files
vim.opt.backup = false            -- don't create backup of configuration, instead git is being used
vim.opt.undofile = true           -- create undo files, so possible to undo changes after closing the file
vim.opt.undodir = "C://nvim-undo" -- save undo files in the data directory

-- appearance
vim.opt.hlsearch = false       -- don't highlight search results
vim.opt.incsearch = true       -- highlight matches search when typing
vim.opt.termguicolors = true   -- true color support
vim.opt.scrolloff = 8          -- keep 8 lines when scrolling
vim.opt.signcolumn = "no"      -- don't show sign column
vim.opt.isfname:append("@-@")  -- allow filenames with @
vim.opt.updatetime = 50        -- update interval for rerendering the screen
vim.opt.colorcolumn = "9999"   -- remove identline
vim.opt.conceallevel = 2       -- show markdown as it is
vim.opt.cursorline = false     -- don't highlight the current line
vim.opt.fileencoding = "utf-8" -- the encoding written to a file
vim.opt.showmode = false       -- hide things like -- INSERT
vim.opt.ruler = false          -- hide things like line, column, TOP at the status bar position
vim.opt.showtabline = 1        -- show tabs if more then one
vim.opt.laststatus = 0         -- 0 - hide stats bar, 2 - always show status bar
vim.opt.cmdheight = 1          -- height of the command bar

-- code folding
-- vim.opt.foldmethod = "manual"                     -- fold based on expression
vim.opt.foldexpr = "nvim_treesitter#foldexpr()" -- use treesitter expressions for folding
vim.opt.foldlevel = 99                          -- keep everything unfold by default
