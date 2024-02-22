-- show netrw
-- vim.keymap.set("n", "<leader>q", vim.cmd.Ex)

-- allows to move selected lines up/bottom
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keeps cursor at the middle of the screen when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- insert, paste without updating the buffer
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>d", "\"_d")

-- yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- lsp part, probably make sens to put into lsp.lua
vim.keymap.set("n", "<leader>f", function()
	vim.lsp.buf.format()
end)
vim.keymap.set("n", "<C-k>",vim.diagnostic.goto_prev)
vim.keymap.set("n", "<C-j>",vim.diagnostic.goto_next)
vim.keymap.set("n", "<leader>k", "<cmd>lnext<CR>zz")
vim.keymap.set("n", "<leader>j", "<cmd>lprev<CR>zz")

-- replace all occurences of the current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- exit from edit in terminal mode
vim.keymap.set("t", "Esc", "<C-\\><C-n>")

vim.keymap.set("n", "<A-l>", vim.cmd.LazyGit)
vim.keymap.set("n", "<leader>l", vim.cmd.Lazy)
vim.keymap.set("n", "<leader>d", vim.diagnostic.open_float)

-- navigation in command mode
vim.keymap.set("c", "<C-h>", "<Left>")
vim.keymap.set("c", "<C-l>", "<Right>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")

-- execute in browser
vim.keymap.set("n", "<leader>eb", ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"")
