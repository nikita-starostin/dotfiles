return {
  {
    "nvim-neo-tree/neo-tree.nvim",
    branch = "v3.x",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-tree/nvim-web-devicons",
      "MunifTanjim/nui.nvim",
    },
    init = function()
      -- The control-panel CLI owns the activity board source and writes it to
      -- its "generated" directory. Expose it to `require("activity_board.*")`.
      local generated_lua = "C:/projects/public_vault/03 Resources/apps/control-panel/cli/generated/lua"
      package.path = package.path
        .. ";"
        .. generated_lua
        .. "/?.lua;"
        .. generated_lua
        .. "/?/init.lua"
    end,
    opts = {
      sources = { "filesystem", "activity_board.source" },
      default_source = "activities",
      filesystem = {
        -- oil.nvim is the file browser; keep neo-tree from hijacking netrw.
        hijack_netrw_behavior = "disabled",
      },
    },
  },
}
