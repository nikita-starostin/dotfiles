return {
  -- nice rename and promts for input
  {
    'stevearc/dressing.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require("dressing").setup({
        input = {
          -- Set to false to disable the vim.ui.input implementation
          enabled = true,

          -- Default prompt string
          default_prompt = "Input",

          -- Trim trailing `:` from prompt
          trim_prompt = true,

          -- Can be 'left', 'right', or 'center'
          title_pos = "left",

          -- When true, <Esc> will close the modal
          insert_only = true,

          -- When true, input will start in insert mode.
          start_in_insert = true,

          -- These are passed to nvim_open_win
          border = "rounded",
          -- 'editor' and 'win' will default to being centered
          relative = "cursor",

          -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
          prefer_width = 40,
          width = nil,
          -- min_width and max_width can be a list of mixed types.
          -- min_width = {20, 0.2} means "the greater of 20 columns or 20% of total"
          max_width = { 140, 0.9 },
          min_width = { 20, 0.2 },

          buf_options = {},
          win_options = {
            -- Disable line wrapping
            wrap = false,
            -- Indicator for when text exceeds window
            list = true,
            listchars = "precedes:…,extends:…",
            -- Increase this for more context when text scrolls off the window
            sidescrolloff = 0,
            winhighlight = 'NormalFloat:DiagnosticError'
          },

          -- Set to `false` to disable
          mappings = {
            n = {
              ["<Esc>"] = "Close",
              ["<CR>"] = "Confirm",
            },
            i = {
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
              ["<Up>"] = "HistoryPrev",
              ["<Down>"] = "HistoryNext",
            },
          },

          override = function(conf)
            -- This is the config that will be passed to nvim_open_win.
            -- Change values here to customize the layout
            return conf
          end,

          -- see :help dressing_get_config
          get_config = nil,
        },
        select = {
          -- Set to false to disable the vim.ui.select implementation
          enabled = true,

          -- Priority list of preferred vim.select implementations
          backend = { "telescope", "fzf_lua", "fzf", "builtin", "nui" },

          -- Trim trailing `:` from prompt
          trim_prompt = true,

          -- Options for telescope selector
          -- These are passed into the telescope picker directly. Can be used like:
          -- telescope = require('telescope.themes').get_ivy({...})
          telescope = nil,

          -- Options for fzf selector
          fzf = {
            window = {
              width = 0.5,
              height = 0.4,
            },
          },

          -- Options for fzf-lua
          fzf_lua = {
            -- winopts = {
            --   height = 0.5,
            --   width = 0.5,
            -- },
          },

          -- Options for nui Menu
          nui = {
            position = "50%",
            size = nil,
            relative = "editor",
            border = {
              style = "rounded",
            },
            buf_options = {
              swapfile = false,
              filetype = "DressingSelect",
            },
            win_options = {
              winblend = 0,
            },
            max_width = 80,
            max_height = 40,
            min_width = 40,
            min_height = 10,
          },

          -- Options for built-in selector
          builtin = {
            -- Display numbers for options and set up keymaps
            show_numbers = true,
            -- These are passed to nvim_open_win
            border = "rounded",
            -- 'editor' and 'win' will default to being centered
            relative = "editor",

            buf_options = {},
            win_options = {
              cursorline = true,
              cursorlineopt = "both",
            },

            -- These can be integers or a float between 0 and 1 (e.g. 0.4 for 40%)
            -- the min_ and max_ options can be a list of mixed types.
            -- max_width = {140, 0.8} means "the lesser of 140 columns or 80% of total"
            width = nil,
            max_width = { 140, 0.8 },
            min_width = { 40, 0.2 },
            height = nil,
            max_height = 0.9,
            min_height = { 10, 0.2 },

            -- Set to `false` to disable
            mappings = {
              ["<Esc>"] = "Close",
              ["<C-c>"] = "Close",
              ["<CR>"] = "Confirm",
            },

            override = function(conf)
              -- This is the config that will be passed to nvim_open_win.
              -- Change values here to customize the layout
              return conf
            end,
          },

          -- Used to override format_item. See :help dressing-format
          format_item_override = {},

          -- see :help dressing_get_config
          get_config = nil,
        },
      })
    end
  },
  -- status bar
  {
    'nvim-lualine/lualine.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    depencies = {
      'nveem-tree/nvim-web-devicons',
    },
    config = function()
      local CTimeLine = require('lualine.component'):extend()

      CTimeLine.init = function(self, options)
        CTimeLine.super.init(self, options)
      end

      CTimeLine.update_status = function(_)
        return os.date("%m/%d %H:%M", os.time())
      end

      local CGitState = require('lualine.component'):extend()
      CGitState.init = function(self, options)
        CGitState.super.init(self, options)
      end

      CGitState.update_status = function(_)
        local branch = vim.fn.system("git branch --show-current")
        local isEverythingCommitted = vim.fn.system("git status --porcelain") == ""
        local isEverythingPushed = vim.fn.system("git status --porcelain -b") == ""

        return string.format(
          "%s | %s | %s",
          branch,
          isEverythingCommitted and "Commited" or "Uncommitted",
          isEverythingPushed and "Pushed" or "Unpushed"
        )
      end

      local colors = {
        black        = '#292929',
        white        = '#ebdbb2',
        red          = '#fb4934',
        green        = '#b8bb26',
        blue         = '#83a598',
        yellow       = '#fe8019',
        gray         = '#292929',
        darkgray     = '#1d2021',
        lightgray    = '#504945',
        inactivegray = '#7c6f64',
      }

      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = {
            normal = {
              a = { bg = colors.blue, fg = colors.darkgray, gui = 'bold' },
              b = { bg = colors.darkgray, fg = colors.darkgray },
              c = { bg = colors.darkgray, fg = colors.darkgray }
            },
            insert = {
              a = { bg = colors.darkgray, fg = colors.darkgray, gui = 'bold' },
              b = { bg = colors.darkgray, fg = colors.darkgray },
              c = { bg = colors.darkgray, fg = colors.darkgray }
            },
            visual = {
              a = { bg = colors.darkgray, fg = colors.darkgray, gui = 'bold' },
              b = { bg = colors.darkgray, fg = colors.darkgray },
              c = { bg = colors.darkgray, fg = colors.darkgray }
            },
            replace = {
              a = { bg = colors.darkgray, fg = colors.darkgray, gui = 'bold' },
              b = { bg = colors.darkgray, fg = colors.darkgray },
              c = { bg = colors.darkgray, fg = colors.darkgray }
            },
            command = {
              a = { bg = colors.darkgray, fg = colors.darkgray, gui = 'bold' },
              b = { bg = colors.darkgray, fg = colors.darkgray },
              c = { bg = colors.darkgray, fg = colors.darkgray }
            },
            inactive = {
              a = { bg = colors.darkgray, fg = colors.darkgray, gui = 'bold' },
              b = { bg = colors.darkgray, fg = colors.darkgray },
              c = { bg = colors.darkgray, fg = colors.darkgray }
            }
          },
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
          disabled_filetypes = {
            statusline = {},
            winbar = {},
          },
          ignore_focus = {},
          always_divide_middle = true,
          globalstatus = false,
          refresh = {
            statusline = 1000,
            tabline = 1000,
            winbar = 1000,
          }
        },
        sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = { 'diagnostics' },
          lualine_x = {},
          lualine_y = {},
          lualine_z = { CTimeLine }
        },
        inactive_sections = {
          lualine_a = {},
          lualine_b = {},
          lualine_c = {},
          lualine_x = {},
          lualine_y = {},
          lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {}
      }
    end
  },
  -- show all text in the middle of the screen, sometimes usefull on wide screens
  {
    "shortcuts/no-neck-pain.nvim",
    version = "*",
    lazy = true,
    keys = { "<leader>np" },
    config = function()
      require("no-neck-pain").setup({})
      vim.keymap.set("n", "<leader>np", "<cmd>NoNeckPain<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>npp", "<cmd>NoNeckPainWidthUp<cr>", { noremap = true, silent = true })
      vim.keymap.set("n", "<leader>npn", "<cmd>NoNeckPainWidthDown<cr>", { noremap = true, silent = true })
    end,
  },
}
