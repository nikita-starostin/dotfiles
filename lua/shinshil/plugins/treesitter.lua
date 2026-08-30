return {
  "nvim-treesitter/nvim-treesitter",
  build = ":TSUpdate",
  lazy = false, -- the rewritten plugin does not support lazy-loading
  config = function()
    require("shinshil.setup.treesitter_setup")
  end,
}
