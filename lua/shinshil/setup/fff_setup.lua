-- FFF setup with navigation keymaps matching the previous telescope config:
--   <C-s>  -> vertical split (was telescopeActions.file_vsplit)
--   <C-v>  -> horizontal split
--   <C-j>  -> move selection down
--   <C-k>  -> move selection up
--   <Tab>  -> toggle selection (multi-select)
--   <C-q>  -> send selection to quickfix
--   <C-u>  -> clear the query (mapped below, so preview scroll moves to <C-b>)
require("fff").setup({
  keymaps = {
    close = "<Esc>",
    select = "<CR>",
    select_split = "<C-v>",
    select_vsplit = "<C-s>",
    select_tab = "<C-t>",
    move_up = { "<Up>", "<C-k>", "<C-p>" },
    move_down = { "<Down>", "<C-j>", "<C-n>" },
    preview_scroll_up = "<C-b>",
    preview_scroll_down = "<C-d>",
    toggle_select = "<Tab>",
    send_to_quickfix = "<C-q>",
  },
})

-- <C-u> clears the current query while typing in the fff prompt
local function clear_fff_query(bufnr)
  local prompt = vim.fn.prompt_getprompt(bufnr)
  if not prompt or prompt == "" then
    prompt = "> "
  end
  vim.api.nvim_set_option_value("modifiable", true, { buf = bufnr })
  vim.api.nvim_buf_set_lines(bufnr, 0, -1, false, { prompt })
  vim.schedule(function()
    if vim.api.nvim_buf_is_valid(bufnr) then
      vim.api.nvim_win_set_cursor(0, { 1, #prompt })
      vim.cmd("startinsert!")
    end
  end)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "fff_input",
  callback = function(args)
    vim.keymap.set("i", "<C-u>", function()
      clear_fff_query(args.buf)
    end, { buffer = args.buf, noremap = true, silent = true, desc = "Clear fff query" })
  end,
})
