return {
  {
    'nvim-lualine/lualine.nvim',
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
        extensions = { 'fugitive' }
      }
    end
  }
}
