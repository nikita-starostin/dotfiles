-- file picking / grep is handled by fff.nvim, telescope keeps the rest
vim.keymap.set("n", "<Tab>", function()
  require("fff").find_files()
end, { desc = "look files in project dir" })

-- open the file picker prefilled with the current buffer's directory
-- (relative to the project root, trailing slash = directory constraint)
vim.keymap.set("n", "<leader>lid", function()
  local dir = vim.fn.expand("%:p:h")
  if dir == "" then
    dir = vim.fn.getcwd()
  end
  local rel = vim.fn.fnamemodify(dir, ":."):gsub("\\", "/")
  if rel == "." or rel == "" then
    rel = ""
  elseif not rel:match("/$") then
    rel = rel .. "/"
  end
  require("fff").find_files({ query = rel })
end, { desc = "look files in current buffer dir" })

-- greps
vim.keymap.set("n", "<leader>lg", function()
  -- regex first in the modes list => opens in regex mode by default
  require("fff").live_grep({ grep = { modes = { "regex", "plain", "fuzzy" } } })
end, { desc = "look for a text in nvim directory" })
vim.keymap.set("v", "<leader>lg", function()
  require("fff").live_grep_under_cursor()
end, { desc = "look for selection in nvim directory" })

-- static grep of the word under cursor / selection
vim.keymap.set("n", "<leader>ls", function()
  require("fff").live_grep_under_cursor()
end, { desc = "look for a static text in nvim directory" })
vim.keymap.set("v", "<leader>ls", function()
  require("fff").live_grep_under_cursor()
end, { desc = "look for a static text in nvim directory" })

-- resume last look
vim.keymap.set("n", "<leader>lr", function()
  require("fff").resume()
end, { desc = "resume last look" })
