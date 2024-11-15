return {
  -- plugin to repeat some actions with ., e.g. vim-surround
  {
    'tpope/vim-repeat',
  },

  -- plugin to comment/uncomment code
  {
    'numToStr/Comment.nvim',
    opts = {
      -- add any options here
    }
  },

  -- plugin to surround text with brackets, quotes, etc.
  {
    'tpope/vim-surround',
  },

  -- better wrapping of long text
  {
    'preservim/vim-pencil'
  },

  -- enhance navigation in code, so don't need to press n or ; multiple times
  {
    'smoka7/hop.nvim',
    version = 'v2.7.2', -- hardcoded version according to advice from smoka7/hop.nvim
    config = function()
      require('shinshil.setup.hop_setup')
    end
  },
}
