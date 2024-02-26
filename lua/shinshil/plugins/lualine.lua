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

      CTimeLine.update_status = function(self)
        return os.date("%m/%d %H:%M", os.time())
      end

      require('lualine').setup {
        options = {
          icons_enabled = false,
          theme = 'auto',
          component_separators = { left = '', right = '' },
          section_separators = { left = '', right = '' },
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
          lualine_a = { },
          lualine_b = { 'branch' },
          lualine_c = { 'diff', 'diagnostics' },
          lualine_x = { },
          lualine_y = { },
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
  }
}
