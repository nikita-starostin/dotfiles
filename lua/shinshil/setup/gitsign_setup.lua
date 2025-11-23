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
vim.keymap.set("n", "<leader>gu", ":Gitsigns undo_stage_hunk<CR>", { desc = "reset hunk" })
vim.keymap.set("n", "<leader>gsc", ":Gitsigns show_commit<CR>", { desc = "show commit for the current buffer" })

local listeners = {}
local counter = 0

function add_listener(fn)
  table.insert(listeners, fn)
end

function remove_listener(fn)
  for i, v in ipairs(listeners) do
    if v == fn then
      table.remove(listeners, i)
      break
    end
  end
end

vim.on_key(function(key)
  for _, fn in ipairs(listeners) do
    fn(key)
  end
end)

local hunk_preview_shown = false

function tryToResetHunkPreviewShown(key)
  -- ignore if in insert or command mode
  if vim.api.nvim_get_mode().mode ~= "n" then
    return
  end

  counter = counter - 1
  if (counter < 0) then 
    print('removing prevew')
    remove_listener(tryToResetHunkPreviewShown)
    hunk_preview_shown = false
    counter = 0;
  end
end

function enableHunkHighLightIfNotEnabled()
  print('try to enable highlight: ', counter, hunk_preview_shown)
  counter = 6
  if hunk_preview_shown == false then
    add_listener(tryToResetHunkPreviewShown)
    local status, err = pcall(vim.cmd, "Gitsigns preview_hunk");
    print('status', status)
    print('err', err)
    print('Higlighted')
    hunk_preview_shown = true
  end
end

vim.keymap.set("n", "]]", ":Gitsigns preview_hunk<CR>", {desc = "Preview hunk / jump inside of hunk", noremap = true})

vim.keymap.set("n", "]h", function()
  local status, err = pcall(vim.cmd, "Gitsigns nav_hunk next")
  if not status then
    -- Navigation failed, reset preview flag and optionally notify or ignore
    hunk_preview_shown = false
    return
  end
  -- FUCKING SHIT, IT NOT WORKING!!!! enableHunkHighLightIfNotEnabled();
end , { desc = "jump to next hunk" })

vim.keymap.set("n", "[h", function()
  local status, err = pcall(vim.cmd, "Gitsigns nav_hunk prev")
  if not status then
    -- Navigation failed, reset preview flag and optionally notify or ignore
    hunk_preview_shown = false
    return
  end
  enableHunkHighLightIfNotEnabled();
end, { desc = "jump to prev hunk" })

print 'Loaded gitsigns setup'
