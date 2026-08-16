-- Oil sort state and helpers (used by the buffer-local keymaps below)
local oil_sort = {
  dirs_on_top = true,
  key = "name", -- active sort column: "name" | "mtime" | "size" | nil (off)
  order = "asc", -- active direction: "asc" | "desc"
}

local sort_modes = {
  name = {
    default = "asc",
    cols = function(order)
      return { { "name", order } }
    end,
  },
  mtime = {
    default = "desc",
    cols = function(order)
      return { { "mtime", order }, { "name", "asc" } }
    end,
  },
  size = {
    default = "desc",
    cols = function(order)
      return { { "size", order }, { "name", "asc" } }
    end,
  },
}

local function build_sort(key, order)
  local spec = {}
  if oil_sort.dirs_on_top then
    table.insert(spec, { "type", "asc" })
  end
  for _, col in ipairs(sort_modes[key].cols(order)) do
    table.insert(spec, col)
  end
  return spec
end

local function toggle_sort(key)
  local mode = sort_modes[key]
  if oil_sort.key == key then
    if oil_sort.order == mode.default then
      oil_sort.order = mode.default == "asc" and "desc" or "asc"
    else
      -- third press of the same key turns sorting off
      oil_sort.key = nil
      oil_sort.order = nil
      require("oil").set_sort({})
      return
    end
  else
    oil_sort.key = key
    oil_sort.order = mode.default
  end
  require("oil").set_sort(build_sort(oil_sort.key, oil_sort.order))
end

local function sort_off()
  oil_sort.key = nil
  oil_sort.order = nil
  require("oil").set_sort({})
end

local function toggle_dirs_on_top()
  oil_sort.dirs_on_top = not oil_sort.dirs_on_top
  if oil_sort.key then
    require("oil").set_sort(build_sort(oil_sort.key, oil_sort.order))
  end
end

-- metadata columns can be toggled between a minimal and a detailed view
local detail_view = true
local function toggle_detail()
  detail_view = not detail_view
  require("oil").set_columns(detail_view and { "icon", "size", "mtime" } or { "icon" })
end

-- Winbar showing the current oil directory (home-compacted path + folder icon)
function _G.get_oil_winbar()
  local ok, dir = pcall(function()
    return require("oil").get_current_dir()
  end)
  if not ok or not dir then
    return vim.api.nvim_buf_get_name(0)
  end
  local home = vim.env.HOME
  if not home or home == "" then
    home = vim.env.USERPROFILE
  end
  if home and home ~= "" then
    home = home:gsub("\\", "/")
  end
  dir = dir:gsub("\\", "/")
  if home and home ~= "" and vim.startswith(dir, home) then
    dir = "~" .. dir:sub(#home + 1)
  end
  if not vim.endswith(dir, "/") then
    dir = dir .. "/"
  end
  return " " .. "󰉋 " .. dir
end

-- Create a file or directory inside the current oil directory.
local function create_entry(kind)
  local oil = require("oil")
  local dir = oil.get_current_dir()
  if not dir then
    return
  end
  local prompt = kind == "dir" and "Create directory: " or "Create file: "
  vim.ui.input({ prompt = prompt }, function(name)
    if not name or name == "" then
      return
    end
    local path = vim.fs.joinpath(dir, name)
    if kind == "dir" then
      vim.fn.mkdir(path, "p")
    else
      local f = io.open(path, "a")
      if f then
        f:close()
      end
    end
    require("oil.actions").refresh.callback()
  end)
end

-- 'd' in oil normal mode: create a directory if no motion follows within 200ms.
-- Otherwise leave the 'd' operator alone so motions like 'dd' keep working.
local d_watch = { pending = false, timer = nil }
local d_watch_ns = vim.api.nvim_create_namespace("oil_create_dir")

local function cancel_d_watch()
  d_watch.pending = false
  if d_watch.timer then
    d_watch.timer:stop()
    d_watch.timer:close()
    d_watch.timer = nil
  end
end

vim.on_key(function(char, typed)
  if not typed or vim.bo.filetype ~= "oil" then
    return
  end
  if char == "d" then
    if d_watch.pending then
      cancel_d_watch()
    elseif vim.fn.mode() == "n" then
      d_watch.pending = true
      d_watch.timer = vim.uv.new_timer()
      d_watch.timer:start(200, 0, vim.schedule_wrap(function()
        if not d_watch.pending then
          return
        end
        cancel_d_watch()
        create_entry("dir")
      end))
    end
  elseif d_watch.pending then
    cancel_d_watch()
  end
end, d_watch_ns)

return {
  {
    'stevearc/oil.nvim',
    ---@module 'oil'
    ---@type oil.SetupOpts
    opts = {
      -- Oil will take over directory buffers (e.g. `vim .` or `:e src/`)
      -- Set to false if you want some other plugin (e.g. netrw) to open when you edit directories.
      default_file_explorer = false,
      -- Id is automatically added at the beginning, and name at the end
      -- See :help oil-columns
      columns = {
        "icon",
        -- "permissions",
        "size",
        "mtime",
      },
      -- Buffer-local options to use for oil buffers
      buf_options = {
        buflisted = false,
        bufhidden = "hide",
      },
      -- Window-local options to use for oil buffers
      win_options = {
        wrap = false,
        signcolumn = "no",
        cursorcolumn = false,
        foldcolumn = "0",
        spell = false,
        list = false,
        conceallevel = 3,
        concealcursor = "nvic",
        winbar = "%!v:lua.get_oil_winbar()",
      },
      -- Send deleted files to the trash instead of permanently deleting them (:help oil-trash)
      delete_to_trash = false,
      -- Skip the confirmation popup for simple operations (:help oil.skip_confirm_for_simple_edits)
      skip_confirm_for_simple_edits = false,
      -- Selecting a new/moved/renamed file or directory will prompt you to save changes first
      -- (:help prompt_save_on_select_new_entry)
      prompt_save_on_select_new_entry = true,
      -- Oil will automatically delete hidden buffers after this delay
      -- You can set the delay to false to disable cleanup entirely
      -- Note that the cleanup process only starts when none of the oil buffers are currently displayed
      cleanup_delay_ms = 2000,
      lsp_file_methods = {
        -- Enable or disable LSP file operations
        enabled = false,
        -- Time to wait for LSP file operations to complete before skipping
        timeout_ms = 1000,
        -- Set to true to autosave buffers that are updated with LSP willRenameFiles
        -- Set to "unmodified" to only save unmodified buffers
        autosave_changes = false,
      },
      -- Constrain the cursor to the editable parts of the oil buffer
      -- Set to `false` to disable, or "name" to keep it on the file names
      constrain_cursor = "editable",
      -- Set to true to watch the filesystem for changes and reload oil
      watch_for_changes = false,
      -- Keymaps in oil buffer. Can be any value that `vim.keymap.set` accepts OR a table of keymap
      -- options with a `callback` (e.g. { callback = function() ... end, desc = "", mode = "n" })
      -- Additionally, if it is a string that matches "actions.<name>",
      -- it will use the mapping at require("oil.actions").<name>
      -- Set to `false` to remove a keymap
      -- See :help oil-actions for a list of all available actions
      keymaps = {
        ["g?"] = "actions.show_help",
        ["<CR>"] = "actions.select",
        ["<C-s>"] = { "actions.select", opts = { vertical = true }, desc = "Open the entry in a vertical split" },
        ["<C-h>"] = { "actions.select", opts = { horizontal = true }, desc = "Open the entry in a horizontal split" },
        ["<C-t>"] = { "actions.select", opts = { tab = true }, desc = "Open the entry in new tab" },
        ["<C-p>"] = "actions.preview",
        ["<C-c>"] = "actions.close",
        ["<C-l>"] = "actions.refresh",
        ["-"] = "actions.parent",
        ["<BS>"] = "actions.parent",
        ["_"] = "actions.open_cwd",
        ["`"] = "actions.cd",
        ["~"] = { "actions.cd", opts = { scope = "tab" }, desc = ":tcd to the current oil directory", mode = "n" },
        ["gs"] = "actions.change_sort",
        ["gx"] = "actions.open_external",
        ["g."] = "actions.toggle_hidden",
        ["g\\"] = "actions.toggle_trash",
        ["q"] = "actions.close",
        ["%"] = { callback = function() create_entry("file") end, desc = "Create file" },
        ["gd"] = { callback = toggle_detail, desc = "Toggle file detail view" },
        ["sn"] = { callback = function() toggle_sort("name") end, desc = "Sort by name" },
        ["sm"] = { callback = function() toggle_sort("mtime") end, desc = "Sort by mtime" },
        ["ss"] = { callback = function() toggle_sort("size") end, desc = "Sort by size" },
        ["st"] = { callback = sort_off, desc = "Turn off sort" },
        ["std"] = { callback = toggle_dirs_on_top, desc = "Toggle directories on top" },
      },
      -- Set to false to disable all of the above keymaps
      use_default_keymaps = true,
      view_options = {
        -- Show files and directories that start with "."
        show_hidden = true,
        -- This function defines what is considered a "hidden" file
        is_hidden_file = function(name, bufnr)
          return vim.startswith(name, ".")
        end,
        -- This function defines what will never be shown, even when `show_hidden` is set
        is_always_hidden = function(name, bufnr)
          return false
        end,
        -- Sort file names in a more intuitive order for humans. Is less performant,
        -- so you may want to set to false if you work with large directories.
        natural_order = true,
        -- Sort file and directory names case insensitive
        case_insensitive = true,
        sort = {
          -- sort order can be "asc" or "desc"
          -- see :help oil-columns to see which columns are sortable
          { "type", "asc" },
          { "name", "asc" },
        },
      },
      -- Extra arguments to pass to SCP when moving/copying files over SSH
      extra_scp_args = {},
      -- EXPERIMENTAL support for performing file operations with git
      git = {
        -- Return true to automatically git add/mv/rm files
        add = function(path)
          return false
        end,
        mv = function(src_path, dest_path)
          return false
        end,
        rm = function(path)
          return false
        end,
      },
      -- Configuration for the floating window in oil.open_float
      float = {
        -- Padding around the floating window
        padding = 2,
        max_width = 100,
        max_height = 35,
        border = "rounded",
        win_options = {
          winblend = 0,
          winhighlight = "FloatBorder:OilFloatBorder",
        },
        -- optionally override the oil buffers window title with custom function: fun(winid: integer): string
        get_win_title = nil,
        -- preview_split: Split direction: "auto", "left", "right", "above", "below".
        preview_split = "auto",
        -- This is the config that will be passed to nvim_open_win.
        -- Change values here to customize the layout
        override = function(conf)
          return conf
        end,
      },
      -- Configuration for the actions floating preview window
      preview = {
        -- Width dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_width and max_width can be a single value or a list of mixed integer/float types.
        -- max_width = {100, 0.8} means "the lesser of 100 columns or 80% of total"
        max_width = 0.9,
        -- min_width = {40, 0.4} means "the greater of 40 columns or 40% of total"
        min_width = { 40, 0.4 },
        -- optionally define an integer/float for the exact width of the preview window
        width = nil,
        -- Height dimensions can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
        -- min_height and max_height can be a single value or a list of mixed integer/float types.
        -- max_height = {80, 0.9} means "the lesser of 80 columns or 90% of total"
        max_height = 0.9,
        -- min_height = {5, 0.1} means "the greater of 5 columns or 10% of total"
        min_height = { 5, 0.1 },
        -- optionally define an integer/float for the exact height of the preview window
        height = nil,
        border = "rounded",
        win_options = {
          winblend = 0,
        },
        -- Whether the preview window is automatically updated when the cursor is moved
        update_on_cursor_moved = true,
      },
      -- Configuration for the floating progress window
      progress = {
        max_width = 0.9,
        min_width = { 40, 0.4 },
        width = nil,
        max_height = { 10, 0.9 },
        min_height = { 5, 0.1 },
        height = nil,
        border = "rounded",
        minimized_border = "none",
        win_options = {
          winblend = 0,
        },
      },
      -- Configuration for the floating SSH window
      ssh = {
        border = "rounded",
      },
      -- Configuration for the floating keymaps help window
      keymaps_help = {
        border = "rounded",
      },
    },
    -- Optional dependencies
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- use if prefer nvim-web-devicons
  }
}
