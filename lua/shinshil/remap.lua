-- show netrw
vim.keymap.set("n", "<leader>q", vim.cmd.Ex, { desc = "Show netrw" })

-- show lf
vim.keymap.set("n", "<leader>lf", vim.cmd.LfCurrentDirectory, { desc = "Show lf" })

-- draw diagrams
-- venn.nvim: enable or disable keymappings
function _G.Toggle_venn()
    local venn_enabled = vim.inspect(vim.b.venn_enabled)
    if venn_enabled == "nil" then
        vim.b.venn_enabled = true
        vim.cmd[[setlocal ve=all]]
        -- draw a line on HJKL keystokes
        vim.api.nvim_buf_set_keymap(0, "n", "J", "<C-v>j:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "K", "<C-v>k:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "L", "<C-v>l:VBox<CR>", {noremap = true})
        vim.api.nvim_buf_set_keymap(0, "n", "H", "<C-v>h:VBox<CR>", {noremap = true})
        -- draw a box by pressing "f" with visual selection
        vim.api.nvim_buf_set_keymap(0, "v", "f", ":VBox<CR>", {noremap = true})
        vim.api.nvim_command("echo 'Ven mode enabled'")
    else
        vim.cmd[[setlocal ve=]]
        vim.api.nvim_buf_del_keymap(0, "n", "J")
        vim.api.nvim_buf_del_keymap(0, "n", "K")
        vim.api.nvim_buf_del_keymap(0, "n", "L")
        vim.api.nvim_buf_del_keymap(0, "n", "H")
        vim.api.nvim_buf_del_keymap(0, "v", "f")
        vim.b.venn_enabled = nil
        vim.api.nvim_command("echo 'Ven mode disabled'")
    end
end
-- toggle keymappings for venn using <leader>v
vim.api.nvim_set_keymap('n', '<leader>td', ":lua Toggle_venn()<CR>", { noremap = true, desc = "Toggle diagrams draw mode" })

-- improve command mode
vim.keymap.set("n", "<leader><leader>", ":", { desc = "Run command with double leader" })
vim.keymap.set("n", "<leader>s", ":%s/", { desc = "Run command with double leader", nowait = true })

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
vim.keymap.set("n", "<leader>r", [[:%s/\<<C-r><C-w>\>//gI<Left><Left><Left>]], { desc = "Replace all occurences of the current word" })

-- exit from edit in terminal mode
vim.keymap.set("t", "Esc", "<C-\\><C-n>", { desc = "Exit from edit in terminal mode" })

-- navigation in command mode
vim.keymap.set("c", "<C-h>", "<Left>", { desc = "Move cursor left in command mode" })
vim.keymap.set("c", "<C-l>", "<Right>", { desc = "Move cursor right in command mode" })
vim.keymap.set("c", "<C-j>", "<Down>", { desc = "Move cursor down in command mode" })
vim.keymap.set("c", "<C-k>", "<Up>", { desc = "Move cursor up in command mode" })
-- exit from command mode on double leader
vim.keymap.set("c", "<leader><leader>", "<C-c>", { desc = "Exit from command mode with double leader" })

-- navigation between windows
vim.keymap.set("n", "<C-h>", "<C-w>h", { desc = "Move to the window on the left" })
vim.keymap.set("n", "<C-l>", "<C-w>l", { desc = "Move to the window on the right" })
vim.keymap.set("n", "<C-j>", "<C-w>j", { desc = "Move to the window below" })
vim.keymap.set("n", "<C-k>", "<C-w>k", { desc = "Move to the window above" })

-- splitting windows
vim.keymap.set("n", "<leader>wsv", "<C-w>v", { desc = "Split window vertically" })     -- split window vertically
vim.keymap.set("n", "<leader>wsh", "<C-w>s", { desc = "Split window horizontally" })   -- split window horizontally
vim.keymap.set("n", "<leader>wse", "<C-w>=", { desc = "Make splits equal size" })      -- make split windows equal width & height
vim.keymap.set("n", "<leader>wsx", "<cmd>close<CR>", { desc = "Close current split" }) -- close current split window

-- use jk to exit insert mode
vim.keymap.set("i", "jk", "<Esc>", { desc = "Exit insert mode with jk" })

-- clear search highlights
vim.keymap.set("n", "<leader>nh", ":nohl<CR>", { desc = "Clear search highlights" })

-- increment/decrement numbers
vim.keymap.set("n", "<leader>i", "<C-a>", { desc = "Increment number" }) -- increment
vim.keymap.set("n", "<leader>d", "<C-x>", { desc = "Decrement number" }) -- decrement

-- execute in browser
vim.keymap.set("n", "<leader>eb",
  ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"", { desc = "Execute in browser" })

-- set tab size to 2
vim.keymap.set("n", "<leader>2", ":lua SetTabSize(2)<CR>", { desc = "Set tab size to 2" })
-- set tab size to 4
vim.keymap.set("n", "<leader>4", ":lua SetTabSize(4)<CR>", { desc = "Set tab size to 4" })

-- next buffer
vim.keymap.set("n", "<leader>bn", ":bnext<CR>", { desc = "Next buffer" })
-- previous buffer
vim.keymap.set("n", "<leader>bp", ":bprevious<CR>", { desc = "Previous buffer" })

-- toggle oil
vim.keymap.set('n', '<leader>to', function()
  vim.cmd((vim.bo.filetype == 'oil') and 'bd' or 'Oil')
end, { desc = "Toggle oil" })
