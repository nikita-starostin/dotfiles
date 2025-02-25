return {
  "folke/zen-mode.nvim",
  lazy = true,
  keys = { "<leader>tz" },
  config = function ()
    require('shinshil.setup.zen-mode_setup')
  end
}
