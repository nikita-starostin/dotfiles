local vault_path = "C:/projects/public_vault"
local template_path = vault_path .. "/03 Resources/Templates/Journal.md"

local function open_journal_note(day_offset)
  local target_time = os.time({
    year = tonumber(os.date("%Y")),
    month = tonumber(os.date("%m")),
    day = tonumber(os.date("%d")) + day_offset,
    hour = 12,
  })

  local year = os.date("%Y", target_time)
  local month_name = os.date("%B", target_time)
  local date = os.date("%Y-%m-%d", target_time)

  local relative_path = string.format("11 Journal/%s %s/%s.md", month_name, year, date)
  local note_path = vault_path .. "/" .. relative_path
  local note_dir = vim.fn.fnamemodify(note_path, ":h")

  if vim.fn.isdirectory(note_dir) == 0 then
    vim.fn.mkdir(note_dir, "p")
  end

  if vim.fn.filereadable(note_path) == 0 then
    local template_lines = {}
    if vim.fn.filereadable(template_path) == 1 then
      template_lines = vim.fn.readfile(template_path)
    end
    vim.fn.writefile(template_lines, note_path)
  end

  vim.cmd.edit(vim.fn.fnameescape(note_path))
end

vim.keymap.set("n", "<leader>otd", function()
  open_journal_note(0)
end, { desc = "Open today journal note" })

vim.keymap.set("n", "<leader>otm", function()
  open_journal_note(1)
end, { desc = "Open tomorrow journal note" })
