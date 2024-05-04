return {
  -- integration with lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    keys = { "<leader>z" },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>z", vim.cmd.LazyGit)
    end
  },

  -- inline git blame
  {
    "f-person/git-blame.nvim",
    lazy = true,
    keys = { "<leader>tb" },
    config = function()
      require("gitblame").setup({
        enabled = false,
      })
      vim.keymap.set("n", "<leader>tb", vim.cmd.GitBlameToggle)
    end
  },

  -- fugutive
  {
    "tpope/vim-fugitive",
    keys = { "<leader>gg" },
    lazy = true,
    config = function()
      vim.keymap.set("n", "<leader>gg", ":Git<CR>")
    end
  },
}
