function DebugCurrBuff()
  local values = vim.fn.getbufvar(0, "&")
  for key, value in pairs(values) do
    print(key .. " : " .. value)
  end
end

--
-- function to show current status of editing file
function ShowInfo()
  vim.api.nvim_command("echo expand('%:p') . ' | ' . line('.') . ':' . col('.')")
end

vim.keymap.set("n", "<leader>h", ShowInfo, { nowait = false })

-- function to show current status of the current branch
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
  local isEverythingPushed = vim.fn.system("git status --porcelain -b")
  if isEverythingPushed == "" then
    resultMessage = resultMessage .. "pushed"
  else
    resultMessage = resultMessage .. "unpushed"
  end
  vim.api.nvim_command("echo '" .. resultMessage .. "'")
end

vim.keymap.set("n", "<leader>b", ShowBranch, { nowait = false, silent = true })

