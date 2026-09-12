-- Stock catppuccin, zero overrides: `setup()` with no args resets M.options to
-- pure upstream defaults (catppuccin init.lua: tbl_deep_extend("keep", {}, defaults)),
-- and the setup hash change forces a recompile, so no stale cache survives.
-- On-demand only. Registers NO lazy plugin (returns {}), never fights theme.lua.
--
-- Usage:
--   ThemeStock  or  <leader>t1  -> stock catppuccin-mocha, no rewrites
--   <leader>t0                   -> back to my theme.lua (defined there)
--   <leader>t2                   -> old theme_old.lua backup

local function apply_stock()
  require("catppuccin").setup() -- pure upstream defaults
  vim.cmd.colorscheme("catppuccin-mocha")
  vim.notify("Stock catppuccin mocha, no overrides (t0 = mine, t2 = old)", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("ThemeStock", apply_stock, { desc = "Stock catppuccin mocha, no overrides" })
vim.keymap.set("n", "<leader>t1", apply_stock, { desc = "Stock catppuccin mocha" })

return {}
