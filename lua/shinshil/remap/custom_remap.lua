-- execute in browser
vim.keymap.set("n", "<leader>eb",
  ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"",
  { desc = "Execute in browser" })

-- set tab size to 2
vim.keymap.set("n", "<leader>2", ":lua SetTabSize(2)<CR>", { desc = "Set tab size to 2" })
vim.keymap.set("n", "<leader>4", ":lua SetTabSize(4)<CR>", { desc = "Set tab size to 4" })

-- show info about current file
function ShowInfo()
  vim.api.nvim_command("echo expand('%:p') . ' | ' . line('.') . ':' . col('.')")
end

vim.keymap.set("n", "<leader>h", ShowInfo, { nowait = false, desc = "Show current file info" })

vim.g.zenmode = false
vim.keymap.set("n", "<leader>x", function()
  if vim.g.zenmode then
    vim.g.zenmode = false
    vim.api.nvim_feedkeys(":ZenMode | PencilOff | set nolist\n", "n", true)
  else
    vim.g.zenmode = true
    vim.api.nvim_feedkeys(":ZenMode | PencilSoft | set list listchars=tab:>\\\\,trail:$,eol:$,precedes:^,lead:.\n", "n", true)
  end
end, { desc = "Toggle zen mode" })
