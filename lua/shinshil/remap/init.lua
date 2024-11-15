require('shinshil.remap.telescope_remap')
require('shinshil.remap.dir-telescope_remap')
require('shinshil.remap.oil_remap')
require('shinshil.remap.diagrams_remap')
require('shinshil.remap.lf_remap')
require('shinshil.remap.scratch_remap')
require('shinshil.remap.hop_remap')
require('shinshil.remap.custom_remap')

-- optimize some common keys to don't leave fingers from home row
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })
vim.keymap.set("n", "<leader>q", vim.cmd.Ex, { desc = "Show netrw" })
vim.keymap.set("v", "<leader><leader>", "<C-c>", { desc = "Escape from visual mode" })
vim.keymap.set("c", "<leader><leader>", "<C-c>", { desc = "Exit from command mode with double leader" })
vim.keymap.set("n", "<leader><leader>", ":", { desc = "Run command with double leader" })
vim.keymap.set("v", "<leader>n", "y<C-c>/<C-r>0<Enter>", { desc = "Run command with double leader" })
vim.keymap.set("n", "<leader>sf", ":%s/", { desc = "Start replace in the file", nowait = true })
vim.keymap.set("n", "<leader>ss", ":s/", { desc = "Start replace in the string", nowait = true })
vim.keymap.set("v", "<leader>r", [[y:%s/\<<C-r>0\>//gI<Left><Left><Left>]],
  { desc = "Substitute selection", nowait = true })
vim.keymap.set("n", "<leader>jf", ":e **/", { desc = "Jump to file" })
vim.keymap.set("n", "<leader>js", ":grep ", { desc = "Jump to search" })
-- vim.keymap.set("n", "<leader>g", [[:g//caddexpr expand("%") . ":" . line(".") . ":" . getline(".")<Home><Right><Right>]],
  -- { desc = "Jump to search" })
vim.keymap.set("i", "<C-v>", "<C-r>+", { desc = "Insert from clipboard" })
vim.keymap.set("n", "<C-v>", "\"+p", { desc = "Paste from clipboard" })
vim.keymap.set("v", "<C-c>", [["+y]], { desc = "Copy to clipboard" })
vim.keymap.set("n", "gw", [[/]], { desc = "Remap default search" })
vim.keymap.set("n", "gW", [[?]], { desc = "Remap default back search" })

-- easy jumping
vim.keymap.set("n", "1", "mA", { desc = "Put first mark", nowait = true })
vim.keymap.set("n", "2", "mS", { desc = "Put second mark", nowait = true })
vim.keymap.set("n", "4", "'S", { desc = "Jump to second mark", nowait = true })
vim.keymap.set("n", "3", "'A", { desc = "Jump to first mark", nowait = true })
vim.keymap.set("n", "<S-Tab>", ":bnext<Enter>", { desc = "jump to next buffer", nowait = true })
vim.keymap.set("n", "<Tab>", ":bprev<Enter>", { desc = "jump to prev buffer", nowait = true })

-- move cursor in command mode
vim.keymap.set("c", "<C-h>", "<Left>", { desc = "Move cursor left in command mode" })
vim.keymap.set("c", "<C-l>", "<Right>", { desc = "Move cursor right in command mode" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Move cursor down in command mode" })
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Move cursor up in command mode" })

-- allows to move selected lines up/bottom
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Move selected lines down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Move selected lines up" })

-- keeps cursor at the middle of the screen when jumping
vim.keymap.set("n", "<C-d>", "<C-d>zz")
vim.keymap.set("n", "<C-u>", "<C-u>zz")
vim.keymap.set("n", "n", "nzzzv")
vim.keymap.set("n", "N", "Nzzzv")

-- delete, paste without updating the buffer
vim.keymap.set("v", "<leader>p", "\"_dP", { desc = "Paste without updating the buffer" })
vim.keymap.set("v", "<leader>d", "\"_d", { desc = "Delete without updating  buffer" })

-- yank to clipboard
vim.keymap.set("n", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("v", "<leader>y", "\"+y", { desc = "Yank to clipboard" })
vim.keymap.set("n", "<leader>Y", "\"+Y", { desc = "Yank to clipboard" })

-- replace all occurences of the current word
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]],
  { desc = "Replace all occurences of the current word" })

-- exit from edit in terminal mode
vim.keymap.set("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit from edit in terminal mode" })

-- navigation between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the window on the left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the window on the right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the window above" })

-- splitting windows, using same keys as in terminal manager, just with leader
vim.keymap.set("n", "<leader>=", "<C-w>v", { desc = "Split window vertically" })             -- split window vertically
vim.keymap.set("n", "<leader>-", "<C-w>s", { desc = "Split window horizontally" })           -- split window horizontally
vim.keymap.set("n", "<leader>se", "<C-w>=", { desc = "Make splits equal size" })             -- make split windows equal width & height
vim.keymap.set("n", "<leader>sx", "<cmd>close<CR>", { desc = "Close (exit) current split" }) -- close current split window

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>i", "<C-a>", { desc = "Increment number" }) -- increment
vim.keymap.set("n", "<leader>d", "<C-x>", { desc = "Decrement number" }) -- decrement

-- next buffer
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- previous buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })
