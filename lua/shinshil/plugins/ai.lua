return {
  {
    'github/copilot.vim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      vim.g.copilot_no_tab_map = true;
      vim.g.copilot_assume_mapped = true;
      vim.g.copilot_tab_fallback = "";
      -- The mapping is set to other key, see custom/lua/mappings
      -- or run <leader>ch to see copilot mapping section
      vim.keymap.set('i', '<C-l>',
        function()
          vim.fn.feedkeys(vim.fn['copilot#Accept'](), '')
        end,
        {
          expr = true,
          replace_keycodes = true,
          nowait = true,
          silent = true,
          noremap = true
        })
    end
  }
}
