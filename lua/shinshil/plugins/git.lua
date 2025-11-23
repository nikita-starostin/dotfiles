return {
  -- integration with lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    keys = { "<leader>z" }, -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>z", vim.cmd.LazyGit, { desc = "show lazyGit" })
    end
  },

  -- work with git inside of the buffer
  {
    "lewis6991/gitsigns.nvim",
    keys = { "<leader>gs" },
    config = function()
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
        attach_to_untracked = false,
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

      vim.keymap.set("n", "<leader>gs", ":Gitsigns toggle_linehl<CR>", { desc = "toggle git signs line higlight" })
      vim.keymap.set("n", "<leader>gtb", ":Gitsigns blame<CR>", { desc = "toggle git blame" })
      vim.keymap.set("n", "<leader>ghs", ":Gitsigns stage_hunk<CR>", { desc = "stage/unstage hunk" })
      vim.keymap.set("n", "<leader>u", ":Gitsigns reset_hunk<CR>", { desc = "reset hunk" })
      vim.keymap.set("n", "]h", ":Gitsigns nav_hunk next<CR>", { desc = "jump to next hunk" })
      vim.keymap.set("n", "[h", ":Gitsigns nav_hunk prev<CR>", { desc = "jump to prev hunk" })
    end
  },

  -- inline git blame
  {
    "f-person/git-blame.nvim",
    lazy = true,
    keys = { "<leader>tb" },
    config = function()
      require("gitblame").setup({
        enabled = false,
      })
      vim.keymap.set("n", "<leader>tb", vim.cmd.GitBlameToggle, { desc = "toggle git blame" })
    end
  },
}
