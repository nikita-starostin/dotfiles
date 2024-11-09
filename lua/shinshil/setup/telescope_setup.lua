local function filename_first(_, path)
  local tail = vim.fs.basename(path)
  local parent = vim.fs.dirname(path)
  if parent == "." then
    return tail
  end
  return string.format("%s\t\t%s", tail, parent)
end

vim.api.nvim_create_autocmd("FileType", {
  pattern = "TelescopeResults",
  callback = function(ctx)
    vim.api.nvim_buf_call(ctx.buf, function()
      vim.fn.matchadd("TelescopeParent", "\t\t.*$")
      -- vim.api.nvim_set_hl(0, "TelescopeParent", { link = "Comment" })
    end)
  end,
})

-- Clone the default Telescope configuration and allow search for hidden, but exclude .git
local telescopeConfig = require("telescope.config")
local vimgrep_arguments = { unpack(telescopeConfig.values.vimgrep_arguments) }
table.insert(vimgrep_arguments, "--hidden")
table.insert(vimgrep_arguments, "--glob")
table.insert(vimgrep_arguments, "!**/.git/*")

local telescopeActions = require('telescope.actions')
local telescope = require('telescope')
telescope.setup {
  defaults = {
    wrap_results = true,
    path_display = filename_first,
    vimgrep_arguments = vimgrep_arguments,
    file_ignore_patterns = {
      "node_modules",
      ".next",
    },
    mappings = {
      i = {
        ["<C-s>"] = telescopeActions.file_vsplit,
        ["<esc>"] = telescopeActions.close,
        ["<C-u>"] = false,
        ["<C-j>"] = {
          telescopeActions.move_selection_next, type = "action",
          opts = { nowait = true, silent = true }
        },
        ["<C-k>"] = {
          telescopeActions.move_selection_previous, type = "action",
          opts = { nowait = true, silent = true }
        },
      }
    }
  },
  pickers = {
    find_files = {
      -- `hidden = true` will still show the inside of `.git/` as it's not `.gitignore`d.
      find_command = { "rg", "--files", "--hidden", "--glob", "!.git" },
    },
  },
}
