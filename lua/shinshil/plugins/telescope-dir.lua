return {
  "princejoogie/dir-telescope.nvim",
  dependecies = { "nvim-telescope/telescope.nvim" },
  config = function()
    require("dir-telescope").setup({
      hidden = true,
      no_ignore = false,
      show_preview = true,
    })

    require("telescope").load_extension("dir")

    vim.keymap.set("n", "<leader>fd", "<cmd>FileInDirectory<CR>", { noremap = true, silent = true })
  end,
}
