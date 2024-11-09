-- execute in browser
vim.keymap.set("n", "<leader>eb",
  ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"", { desc = "Execute in browser" })

-- set tab size to 2
vim.keymap.set("n", "<leader>2", ":lua SetTabSize(2)<CR>", { desc = "Set tab size to 2" })
-- set tab size to 4
vim.keymap.set("n", "<leader>4", ":lua SetTabSize(4)<CR>", { desc = "Set tab size to 4" })

-- toggle dark and light theme
vim.keymap.set("n", "<leader>tt", function()
  local currColor = vim.g.colors_name
  if currColor == 'catppuccin-mocha' then
    SetMyTheme('catppuccin-latte')
  else
    SetMyTheme('catppuccin-mocha')
  end
end, { desc = "Toggle dark and light theme" })

