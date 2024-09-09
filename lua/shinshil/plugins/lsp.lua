return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = { 'BufReadPre', 'BufNewFile' },
    cmd = 'Mason',
    dependencies = {
      'neovim/nvim-lspconfig',
      'hrsh7th/cmp-nvim-lsp',
      'hrsh7th/nvim-cmp',
      'L3MON4D3/LuaSnip',
      'williamboman/mason.nvim',
      'williamboman/mason-lspconfig.nvim',
    },
    config = function()
      local lsp_zero = require('lsp-zero')

      lsp_zero.on_attach(function(client, bufnr)
        lsp_zero.default_keymaps({ buffer = bufnr })
        vim.keymap.set('n', 'gr', '<cmd>Telescope lsp_references<cr>', { buffer = bufnr })
        vim.keymap.set('n', '<leader>r', function()
          vim.lsp.buf.rename()
        end, { nowait = true })
        vim.keymap.set('n', '<leader>c', function()
          vim.lsp.buf.code_action()
        end, { nowait = true })
        vim.keymap.set('n', '<leader>d', function()
          vim.diagnostic.open_float()
        end, { nowait = true })
        vim.keymap.set('n', '<leader>f', function()
          vim.lsp.buf.format()
        end, { nowait = true })
        vim.keymap.set('n', '<leader>c', function()
          vim.lsp.buf.code_action()
        end, { nowait = true })
        vim.keymap.set('n', '<leader>d', function()
          vim.diagnostic.open_float()
        end, { nowait = true })
      end)

      local cmp = require('cmp')

      local function buildCmpFallback(fn)
        return function(fallback)
          if (cmp.visible()) then
            fn()
          else
            fallback()
          end
        end
      end

      cmp.setup {
        mapping = {
          ['<C-u>'] = buildCmpFallback(function()
            cmp.scroll_docs(-4)
          end),
          ['<C-d>'] = buildCmpFallback(function()
            cmp.scroll_docs(4)
          end),
          ['<CR>'] = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Insert })
            else
              fallback()
            end
          end,
          ['<Tab>'] = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
            else
              fallback()
            end
          end,
          ["<C-j>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
          ["<C-k>"] = function(fallback)
            if cmp.visible() then
              cmp.select_prev_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
        },
        sources = {
          { name = 'nvim_lsp' },
          { name = 'buffer' },
          { name = 'orgmode' }
        },
      }

      require('mason').setup({})
      require('mason-lspconfig').setup({
        ensure_installed = {},
        handlers = {
          lsp_zero.default_setup,
          lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
          end,
        },
      })
    end
  },
}
