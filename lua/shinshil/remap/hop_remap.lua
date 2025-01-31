local hop = require('hop')
local directions = require('hop.hint').HintDirection

vim.keymap.set('n', '<C-f>', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true })
end, { desc = "Hop to the next character after the cursor" })
vim.keymap.set('n', '<C-F>', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true })
end, { remap = true, desc = "Hop to the next character before the cursor" })
vim.keymap.set('n', '<C-t>', function()
  hop.hint_char1({ direction = directions.AFTER_CURSOR, current_line_only = true, hint_offset = -1 })
end, { remap = true, desc = "Hop to the previous character after the cursor" })
vim.keymap.set('n', '<C-T>', function()
  hop.hint_char1({ direction = directions.BEFORE_CURSOR, current_line_only = true, hint_offset = 1 })
end, { remap = true, desc = "Hop to the previous character before the cursor" })

vim.keymap.set('n', 'gh', function()
  hop.hint_char2({ current_line_only = false, hint_offset = 0 })
  -- after jump, keep cursor in middle of the screen
  vim.api.nvim_feedkeys('zz', 'n', true)
end, { remap = true, desc = "Hop nvim for two characters" })
