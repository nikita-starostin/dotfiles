return {
  -- obsidian.nvim
  -- that plugins helps to autocomplete and navigate on links when working with obsidian notes
  {
    "epwalsh/obsidian.nvim",
    version = "*", -- recommended, use latest release instead of latest commit
    lazy = true,
    -- next config is to enable when enter to any of the markdown files
    event = "BufEnter *.md",
    ft = "markdown",

    -- next config is to enable when enter to obsidian vault
    -- event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    -- "BufReadPre " .. vim.fn.expand "~" .. "\\OneDrive - Itransition Group\\projects\\obsidian\\public_vault\\**.md",
    -- "BufNewFile " .. vim.fn.expand "~" .. "\\OneDrive - Itransition Group\\projects\\obsidian\\public_vault\\**.md",
    -- },
    dependencies = {
      -- Required.
      "nvim-lua/plenary.nvim",

      -- see below for full list of optional dependencies 👇
      'hrsh7th/nvim-cmp',
      'nvim-telescope/telescope.nvim',
      'nvim-treesitter/nvim-treesitter',
    },
    opts = {
      workspaces = {
        {
          name = "personal",
          path = "~\\OneDrive - Itransition Group\\projects\\obsidian\\public_vault",
        },
      },
      ui = {
        enable = true,
      },
      completion = {
        -- Set to false to disable completion.
        nvim_cmp = true,
        -- Trigger completion at 2 chars.
        min_chars = 2,
      },
      picker = {
        -- Set your preferred picker. Can be one of 'telescope.nvim', 'fzf-lua', or 'mini.pick'.
        name = "telescope.nvim",
        -- Optional, configure key mappings for the picker. These are the defaults.
        -- Not all pickers support all mappings.
        mappings = {
          -- Create a new note from your query.
          new = "<C-x>",
          -- Insert a link to the selected note.
          insert_link = "<C-l>",
        },
      },

      -- see below for full list of options 👇
      new_notes_location = "current_directory"
    },
  },

  -- opens preview of the markdown in the split browser tab
  -- install with yarn or npm
  {
    "iamcco/markdown-preview.nvim",
    cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
    build = "cd app && npm install",
    init = function()
      vim.g.mkdp_filetypes = { "markdown" }
      vim.keymap.set("n", "<leader>tp", "<cmd>MarkdownPreviewToggle<CR>", { desc = "Toggle markdown preview" })
    end,
    ft = { "markdown" },
  },

  -- navigation by headers in markdown
  {
    'AntonVanAssche/md-headers.nvim',
    version = '*',
    opts = {},
    ft = { 'markdown' }, -- Load only for markdown files.
  },

  -- table formatting support
  {
    "dhruvasagar/vim-table-mode",
    lazy = true,
    event = {
      "BufEnter *.md",
      "BufEnter *.org",
    },
    ft = { "markdown", "org" },
  }
}
