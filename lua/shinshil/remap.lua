vim.g.mapleader = " "
vim.g.cursorui = ""

vim.keymap.set("n", "<leader>pv", vim.cmd.Ex)
vim.keymap.set("n", "<C-l>", vim.cmd.Lazy)
vim.keymap.set("i", "<C-space>", "<Cmd>lua vim.lsp.buf.hover()<CR>")

