local journal_engine = require('shinshil.obsidian.journal_engine')

local M = {}

local namespace = vim.api.nvim_create_namespace('shinshil_obsidian_journal')
local enabled = true

local function get_expense_expand_path()
  return vim.g.obsidian_expense_expand_path or '/11 Journal/'
end

local function is_journal_file(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return false
  end

  local normalized = path:gsub('\\', '/')
  return normalized:match('/11 Journal/') ~= nil
end

local function can_expand_expense(bufnr)
  local path = vim.api.nvim_buf_get_name(bufnr)
  if path == '' then
    return false
  end

  local normalized = path:gsub('\\', '/')
  return normalized:find(get_expense_expand_path(), 1, true) ~= nil
end

local function format_hours(seconds)
  local hours = math.floor(seconds / 3600)
  local minutes = math.floor((seconds % 3600) / 60)

  if minutes == 0 then
    return string.format('%dh', hours)
  end

  return string.format('%dh %dm', hours, minutes)
end

local function build_journal_report(bufnr)
  if not is_journal_file(bufnr) then
    return nil
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local parsed = journal_engine.parse_journal(lines)
  if not parsed.header_line then
    return nil
  end

  local report = journal_engine.calculate_tag_stats(parsed.entries)
  if report.total_seconds <= 0 or #report.items == 0 then
    return nil
  end

  local chunks = {}
  for _, item in ipairs(report.items) do
    local percentage = math.floor((item.seconds * 100) / report.total_seconds + 0.5)
    chunks[#chunks + 1] = string.format('%s: %d%% (%s)', item.tag, percentage, format_hours(item.seconds))
  end

  return table.concat(chunks, ' ')
end

local function clear(bufnr)
  vim.api.nvim_buf_clear_namespace(bufnr, namespace, 0, -1)
end

local function render(bufnr)
  clear(bufnr)

  if not enabled then
    return
  end

  if not is_journal_file(bufnr) then
    return
  end

  local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
  local parsed = journal_engine.parse_journal(lines)
  if not parsed.header_line then
    return
  end

  local stats = journal_engine.calculate_chill_stats(parsed.entries)
  if stats.total_seconds <= 0 then
    return
  end

  local percentage = math.floor((stats.chill_seconds * 100) / stats.total_seconds + 0.5)
  local text = string.format('chill %d%% (%s)', percentage, format_hours(stats.chill_seconds))

  vim.api.nvim_buf_set_extmark(bufnr, namespace, parsed.header_line - 1, 0, {
    virt_text = { { ' ' .. text, 'Comment' } },
    virt_text_pos = 'eol',
  })
end

local function refresh_visible_journals()
  for _, bufnr in ipairs(vim.api.nvim_list_bufs()) do
    if vim.api.nvim_buf_is_loaded(bufnr) and is_journal_file(bufnr) then
      render(bufnr)
    end
  end
end

local function feed_tab()
  local keys = vim.api.nvim_replace_termcodes('<Tab>', true, false, true)
  vim.api.nvim_feedkeys(keys, 'n', true)
end

local function expand_expense_or_tab()
  local ok, cmp = pcall(require, 'cmp')
  if ok and cmp.visible() then
    cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
    return
  end

  local bufnr = vim.api.nvim_get_current_buf()
  if not can_expand_expense(bufnr) then
    feed_tab()
    return
  end

  local cursor = vim.api.nvim_win_get_cursor(0)
  local row = cursor[1]
  local col = cursor[2]
  local line = vim.api.nvim_get_current_line()
  local before = line:sub(1, col)
  local start_col, word = before:match('()([%a_]+)$')

  if word ~= 'e' and word ~= 'expense' then
    feed_tab()
    return
  end

  local prefix = before:sub(1, start_col - 1)
  local suffix = line:sub(col + 1)
  local tag = '<expense value="" type="" />'

  vim.api.nvim_set_current_line(prefix .. tag .. suffix)
  vim.api.nvim_win_set_cursor(0, { row, #prefix + #'<expense value="' })
end

function M.setup()
  vim.api.nvim_create_autocmd({ 'BufEnter', 'BufWritePost' }, {
    pattern = '*.md',
    callback = function(args)
      render(args.buf)
    end,
  })

  vim.api.nvim_create_autocmd('FileType', {
    pattern = 'markdown',
    callback = function(args)
      vim.keymap.set('i', '<Tab>', expand_expense_or_tab, {
        buffer = args.buf,
        desc = 'Expand expense tag',
      })
    end,
  })

  vim.keymap.set('n', '<leader>tj', function()
    enabled = not enabled
    refresh_visible_journals()
  end, { desc = 'Toggle journal chill stats' })

  vim.api.nvim_create_user_command('JournalReview', function()
    local report = build_journal_report(vim.api.nvim_get_current_buf())
    if not report then
      vim.api.nvim_echo({ { 'No journal records to review', 'Comment' } }, false, {})
      return
    end
    vim.api.nvim_echo({ { report, 'Normal' } }, false, {})
  end, {})

  vim.keymap.set('n', '<leader>jr', '<cmd>JournalReview<CR>', { desc = 'Show journal review' })
  vim.keymap.set('n', '<leader>ijr', function()
    local report = build_journal_report(vim.api.nvim_get_current_buf())
    if not report then
      vim.api.nvim_echo({ { 'No journal records to review', 'Comment' } }, false, {})
      return
    end
    vim.api.nvim_paste(report, false, -1)
  end, { desc = 'Insert journal review' })
end

M.setup()
