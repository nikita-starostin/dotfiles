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
vim.keymap.set("n", "<leader>tz", function()
  if vim.g.zenmode then
    vim.g.zenmode = false
    vim.api.nvim_feedkeys(":ZenMode | PencilOff | set nolist\n", "n", true)
  else
    vim.g.zenmode = true
    vim.api.nvim_feedkeys(":ZenMode | PencilSoft | set list listchars=tab:>\\\\,trail:$,eol:$,precedes:^,lead:.\n", "n", true)
  end
end, { desc = "Toggle zen mode" })

local qf_open = false
function toggleGitQuickfix()
  if qf_open == true then
    qf_open = false
    vim.cmd("cclose")
    return
  end
  -- Get git affected files without git message lines
  local result = vim.fn.systemlist("git diff --name-only")
  -- Filter out empty lines or git messages (just ensure valid filenames)
  local files = {}
  for _, file in ipairs(result) do
    if file ~= "" 
      and file:sub(1,1) ~= "#"
      and string.sub(file,1,string.len("warning:"))~="warning:"
    then
        table.insert(files, {filename = file})
    end
  end

  -- Populate quickfix list with these files
  vim.fn.setqflist(files, "r")

  -- Open quickfix window
  vim.cmd("copen")
  qf_open = true

  -- Jump to first item
  vim.cmd("cc 1")
end

-- Map <leader>gg to toggle this function
vim.keymap.set("n", "<leader>gg", toggleGitQuickfix, { noremap = true, silent = true })
