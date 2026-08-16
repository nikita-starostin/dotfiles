return {
  "nvim-treesitter/nvim-treesitter",
  event = { 'BufReadPre', 'BufNewFile' },
  config = function()
    -- important, has lot of issues with installing astro
    -- has to use clang from LLVM, but the :TSInstall should be run
    -- when nvim is running in the native tools command prompt for visual studio
    -- which is installed together with visual studio
    -- also need to pay attention to x86 or x64 terminal version,
    -- I don't remember :) But should be x86
    -- Once :TSUpdate, :TSInstall completed, it would be working in powershell as well
    require "nvim-treesitter.install".compilers = { "C:\\Program Files\\LLVM\\bin\\clang.exe" }

    local configs = require("nvim-treesitter.configs")

    vim.filetype.add({extensions = { hurl = "hurl" }})

      configs.setup({
        ensure_installed = {
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
          "org",
        },
        -- install ensure_installed parsers automatically on first load (uses the
        -- clang compiler configured above), so a new PC needs no manual :TSInstall
        sync_install = true,
        auto_install = false,
        highlight = { enable = true },
        indent = { enable = true, disable = { "markdown" } },
        incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "<CR>",
          node_incremental = "<CR>",
          scope_incremental = false,
          node_decremental = "<bs>",
        },
      },
    })
  end
}
