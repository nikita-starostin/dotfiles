-- show netrw
vim.keymap.set("n", "<leader>q", vim.cmd.Ex)

-- allows to move selected lines up/bottom
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv")
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv")

-- keeps cursor at the middle of the screen when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- delete, paste without updating the buffer
vim.keymap.set("x", "<leader>p", "\"_dP")
vim.keymap.set("n", "<leader>d", "\"_d")

-- yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y")
vim.keymap.set("v", "<leader>y", "\"+y")
vim.keymap.set("n", "<leader>Y", "\"+Y")

-- replace all occurences of the current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]])

-- exit from edit in terminal mode
vim.keymap.set("t", "Esc", "<C-\\><C-n>")

-- navigation in command mode
vim.keymap.set("c", "<C-h>", "<Left>")
vim.keymap.set("c", "<C-l>", "<Right>")
vim.keymap.set("c", "<C-j>", "<Down>")
vim.keymap.set("c", "<C-k>", "<Up>")

-- navigation between windows
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-l>", "<C-w>l")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")

-- splitting windows
vim.keymap.set("n", "<leader>sv", "<C-w>v", { desc = "Split window vertically" }) -- split window vertically
vim.keymap.set("n", "<leader>sh", "<C-w>s", { desc = "Split window horizontally" }) -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" }) -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<Esc>")

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>i", "<C-a>", { desc = "Increment number" }) -- increment
vim.keymap.set("n", "<leader>d", "<C-x>", { desc = "Decrement number" }) -- decrement

-- execute in browser
vim.keymap.set("n", "<leader>eb",
  ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"")

-- set tab size to 2
vim.keymap.set("n", "<leader>2", ":lua SetTabSize(2)<CR>", { desc = "Set tab size to 2" })
-- set tab size to 4
vim.keymap.set("n", "<leader>4", ":lua SetTabSize(4)<CR>", { desc = "Set tab size to 4" })

-- jump to default word (react component usually exported with defaul)
vim.keymap.set("n", "gc", "/export default<CR>")

-- next buffer
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- previous buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- work with scratch
vim.keymap.set("n", "<leader>s", "<cmd>Scratch<cr>")
vim.keymap.set("n", "<leader>os", "<cmd>ScratchOpen<cr>")
