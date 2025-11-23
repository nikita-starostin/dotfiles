return {
  -- integration with lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    keys = { "<leader>z" }, -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>z", vim.cmd.LazyGit, { desc = "show lazyGit" })
    end
  },

  -- work with git inside of the buffer
  {
    "lewis6991/gitsigns.nvim",
    keys = {"[h", "]h", "<leader>gg" },
    config = function()
      print('gitsigns init')
      require('shinshil.setup.gitsign_setup');
    end
  },

  -- inline git blame
  {
    "f-person/git-blame.nvim",
    keys = { "<leader>tb" },
    config = function()
      require("gitblame").setup({
        enabled = false,
      })
      vim.keymap.set("n", "<leader>tb", vim.cmd.GitBlameToggle, { desc = "toggle git blame" })
    end
  },
}
