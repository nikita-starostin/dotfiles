vim.loader.enable()
vim.g.mapleader = " "

require("shinshil.set")
require("shinshil.lazy")
require("shinshil.remap")
require("shinshil.utils")

-- open file picker once nvim started
-- (was telescope find_files, now fff. uncomment telescope line to revert)
local ts_group = vim.api.nvim_create_augroup("FffOnEnter", { clear = true })
vim.api.nvim_create_autocmd({ "VimEnter" }, {
  callback = function()
    local first_arg = vim.fn.argv(0)
    if first_arg ~= "" and vim.fn.isdirectory(first_arg) == 1 then
      -- Vim creates a buffer for folder. Close it.
      vim.cmd(":bd 1")
      require("fff").find_files_in_dir(first_arg)
      -- require("telescope.builtin").find_files({ search_dirs = { first_arg } })
    elseif first_arg == "" then
      -- bare startup: just show the file picker
      require("fff").find_files()
    end
  end,
  group = ts_group,
})

