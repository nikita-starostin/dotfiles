-- execute in browser
vim.keymap.set("n", "<leader>eb",
  ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"", { desc = "Execute in browser" })

-- set tab size to 2
vim.keymap.set("n", "<leader>2", ":lua SetTabSize(2)<CR>", { desc = "Set tab size to 2" })
vim.keymap.set("n", "<leader>4", ":lua SetTabSize(4)<CR>", { desc = "Set tab size to 4" })

-- show info about current file
function ShowInfo()
  vim.api.nvim_command("echo expand('%:p') . ' | ' . line('.') . ':' . col('.')") end
vim.keymap.set("n", "<leader>h", ShowInfo, { nowait = false, desc = "Show current file info" })

vim.keymap.set("n", "<leader>x", ":ZenMode | SoftPencil | set list listchars=tab:>\\ ,trail:$,eol:$,precedes:^,lead:.<CR>", { desc = "Toggle zen mode" })
