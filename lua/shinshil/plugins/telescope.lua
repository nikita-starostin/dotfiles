return {
  -- extension for telescope to look for files in some special directory
  {
    "princejoogie/dir-telescope.nvim",
    dependecies = { "nvim-telescope/telescope.nvim" },
    config = function()
      require("dir-telescope").setup({
        hidden = true,
        no_ignore = false,
        show_preview = true,
      })

      require("telescope").load_extension("dir")
    end,
  },

  -- search with telescope
  {
    'nvim-telescope/telescope.nvim',
    tag = '0.1.5',
    dependencies = { 'nvim-lua/plenary.nvim' },
    config = function()
      require('shinshil.setup.telescope_setup');
    end
  }
}
