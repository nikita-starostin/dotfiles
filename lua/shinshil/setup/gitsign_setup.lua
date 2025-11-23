require('gitsigns').setup {
  signs = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged = {
    add          = { text = '┃' },
    change       = { text = '┃' },
    delete       = { text = '_' },
    topdelete    = { text = '‾' },
    changedelete = { text = '~' },
    untracked    = { text = '┆' },
  },
  signs_staged_enable = true,
  signcolumn = false,  -- Toggle with `:Gitsigns toggle_signs`
  numhl      = false, -- Toggle with `:Gitsigns toggle_numhl`
  linehl     = false, -- Toggle with `:Gitsigns toggle_linehl`
  word_diff  = false, -- Toggle with `:Gitsigns toggle_word_diff`
  watch_gitdir = {
    follow_files = true
  },
  newLine = false,
  auto_attach = true,
  attach_to_untracked = true,
  current_line_blame = false, -- Toggle with `:Gitsigns toggle_current_line_blame`
  current_line_blame_opts = {
    virt_text = true,
    virt_text_pos = 'eol', -- 'eol' | 'overlay' | 'right_align'
    delay = 1000,
    ignore_whitespace = false,
    virt_text_priority = 100,
    use_focus = true,
  },
  current_line_blame_formatter = '<author>, <author_time:%R> - <summary>',
  sign_priority = 6,
  update_debounce = 100,
  status_formatter = nil, -- Use default
  max_file_length = 40000, -- Disable if file is longer than this (in lines)
  preview_config = {
    -- Options passed to nvim_open_win
    style = 'minimal',
    relative = 'cursor',
    row = 0,
    col = 1
  },
}

vim.keymap.set("n", "<leader>gl", ":Gitsigns toggle_linehl<CR>", { desc = "toggle git signs line higlight" })
vim.keymap.set("n", "<leader>gb", ":Gitsigns blame<CR>", { desc = "toggle git blame" })
vim.keymap.set("n", "<leader>gs", ":Gitsigns stage_hunk<CR>", { desc = "stage/unstage hunk" })
vim.keymap.set("n", "<leader>gu", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
vim.keymap.set("n", "<leader>gg", ":Gitsigns setloclist target=all<CR>", { desc = "show hunks" })

local prev_hunk_shown = false
vim.keymap.set("n", "]h", function()
  vim.cmd("Gitsigns nav_hunk next");
  print(prev_hunk_shown)
  if prev_hunk_shown == false then
    vim.cmd("Gitsigns preview_hunk");
    prev_hunk_shown = true
  end
end , { desc = "jump to next hunk" })
vim.keymap.set("n", "[h", ":Gitsigns nav_hunk prev<CR>", { desc = "jump to prev hunk" })

local qf_open = false

function toggleGitQuickfix()
  -- If quickfix is open, close and toggle off highlight
  if qf_open then
    vim.cmd("cclose")
    vim.cmd("Gitsigns toggle_linehl")
    qf_open = false
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

  -- Execute Gitsigns commands sequentially
  vim.cmd("Gitsigns refresh")
  vim.defer_fn(function()
    vim.cmd("Gitsigns toggle_linehl")
    vim.cmd("Gitsigns nav_hunk next")
    vim.cmd("Gitsigns preview_hunk")
  end, 1000)
end

-- Map <leader>gg to toggle this function
vim.keymap.set("n", "<leader>gg", toggleGitQuickfix, { noremap = true, silent = true })
