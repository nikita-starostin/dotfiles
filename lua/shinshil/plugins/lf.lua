return {
  {
    'ptzz/lf.vim',
    lazy = true,
    keys = { "<leader>lf" },
    dependencies = {
      'voldikss/vim-floaterm',
    },
    config = function()
      vim.g.lf_map_keys = 0 -- disable default lf keybindings
      vim.g.floaterm_opener = 'drop' -- that settings for the floaterm used under the hood to open floaterm in a floating window
    end
  }
}
