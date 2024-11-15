return {
  {
    'rcarriga/nvim-dap-ui',
    dependencies = {
      'nvim-neotest/nvim-nio', -- async library for lua in neovim
    },
    config = function()
      require('shinshil.setup.nvim-dap-ui_setup')
    end
  },
  {
    'KaiWalter/azure-functions.nvim',
    config = function()
      require("azure-functions").setup({
        compress_log = true,
      })
    end,
  },
  {
    'mfussenegger/nvim-dap',
    config = function()
      require('shinshil.setup.nvim-dap_setup')
    end
  }
}
