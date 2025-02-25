return {
  {
    "mhartington/formatter.nvim",
    event = { 'BufReadPre', 'BufNewFile' },
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
    end
  }
}
