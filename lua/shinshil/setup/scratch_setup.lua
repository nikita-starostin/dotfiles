require("scratch").setup({
  scratch_file_dir = vim.fn.stdpath("cache") .. "/scratch.nvim",     -- where your scratch files will be put
  window_cmd = "rightbelow vsplit",                                  -- 'vsplit' | 'split' | 'edit' | 'tabedit' | 'rightbelow vsplit'
  use_telescope = true,
  -- fzf-lua is recommanded, since it will order the files by modification datetime desc. (require rg)
  file_picker = "telescope",                      -- "fzflua" | "telescope" | nil
  filetypes = { "md", "hurl" },     -- you can simply put filetype here
})
