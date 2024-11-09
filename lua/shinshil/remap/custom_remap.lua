-- execute in browser
vim.keymap.set("n", "<leader>eb",
  ":!start \"\" \"C:\\Program Files\\Google\\Chrome\\Application\\chrome.exe\" \"%:p<CR>\"", { desc = "Execute in browser" })

-- set tab size to 2
vim.keymap.set("n", "<leader>2", ":lua SetTabSize(2)<CR>", { desc = "Set tab size to 2" })
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

-- show info about current file
function ShowInfo()
  vim.api.nvim_command("echo expand('%:p') . ' | ' . line('.') . ':' . col('.')")
end
vim.keymap.set("n", "<leader>h", ShowInfo, { nowait = false, desc = "Show current file info" })

-- show current status of the current branch
function ShowBranch()
  local resultMessage = ""
  local branch = vim.fn.system("git branch --show-current")
  resultMessage = resultMessage .. branch
  local remoteBranchName = vim.fn.system("git rev-parse --abbrev-ref --symbolic-full-name @{u}")
  resultMessage = resultMessage .. remoteBranchName
  local isEverythingCommitted = vim.fn.system("git status --porcelain")
  resultMessage = resultMessage .. "\r"
  if isEverythingCommitted == "" then
    resultMessage = resultMessage .. "committed"
  else
    resultMessage = resultMessage .. "uncommited"
  end
  resultMessage = resultMessage .. " | "
  local isEverythingPushed = vim.fn.system("git status --porcelain")
  if isEverythingPushed == "" then
    resultMessage = resultMessage .. "pushed"
  else
    resultMessage = resultMessage .. "unpushed"
  end
  vim.api.nvim_command("echo '" .. resultMessage .. "'")
end
vim.keymap.set("n", "<leader>b", ShowBranch, { nowait = false, silent = true })
