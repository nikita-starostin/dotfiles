return {
  "LintaoAmons/scratch.nvim",
  lazy = true,
  keys = { "<leader>as", "<leader>os" },
  config = function()
    require("shinshil.setup.scratch_setup");
  end
}
