return {
  -- integration with lazygit
  {
    "kdheepak/lazygit.nvim",
    lazy = true,
    keys = { "<leader>g" },
    -- optional for floating window border decoration
    dependencies = {
      "nvim-lua/plenary.nvim",
    },
    config = function()
      vim.keymap.set("n", "<leader>g", vim.cmd.LazyGit)
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
}
