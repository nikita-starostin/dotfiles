-- Treesitter setup for the rewritten nvim-treesitter (main branch, Neovim 0.12+).
-- This replaces the old `nvim-treesitter.configs` API (ensure_installed, highlight,
-- indent, incremental_selection) which is incompatible with Neovim 0.12.

local parsers = {
  "lua",
  "vim",
  "vimdoc",
  "html",
  "query",
  "typescript",
  "javascript",
  "bicep",
  "c_sharp",
  "css",
  "hurl",
  "markdown",
  "markdown_inline",
}

-- filetypes that get treesitter highlighting (markdown_inline is an injection,
-- so it has no filetype of its own)
local highlight_filetypes = {
  "lua",
  "vim",
  "help",
  "html",
  "query",
  "typescript",
  "javascript",
  "bicep",
  "cs",
  "css",
  "hurl",
  "markdown",
}

require("nvim-treesitter").setup({
  install_dir = vim.fn.stdpath("data") .. "/site",
})

-- Install parsers on first load (no-op once installed). The new installer
-- compiles parsers with tree-sitter-cli, so only attempt it when the CLI is
-- available; otherwise skip to avoid noisy failures on every startup.
if vim.fn.executable("tree-sitter") == 1 then
  require("nvim-treesitter").install(parsers)
end

vim.filetype.add({ extensions = { hurl = "hurl" } })

-- Enable highlighting (provided by Neovim) and indentation (provided by
-- nvim-treesitter) for the supported filetypes.
vim.api.nvim_create_autocmd("FileType", {
  pattern = highlight_filetypes,
  callback = function(args)
    vim.treesitter.start(args.buf)
    if args.match ~= "markdown" then
      vim.bo[args.buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
  end,
})
