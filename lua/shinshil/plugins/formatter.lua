return {
  {
    "mhartington/formatter.nvim",
    config = function()
      require('formatter').setup({
        filetype = {
          typescript = {
            function()
              return {
                exe = "dprint",
                args = { "fmt", "\""..vim.fn.fnameescape(vim.api.nvim_buf_get_name(0)).."\"" },
                stdin = false
              }
            end
          },
        }
      })
      vim.keymap.set('n', '<leader><leader>', ":Format<CR>", { nowait = true })
    end
  }
}
