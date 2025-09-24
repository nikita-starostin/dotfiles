return {
  {
    'VonHeikemen/lsp-zero.nvim',
    branch = 'v3.x',
    event = { 'InsertEnter' },
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
          ['<C-k>'] = function(fallback)
            if cmp.visible() then
              cmp.confirm({ select = true, behavior = cmp.ConfirmBehavior.Replace })
            else
              fallback()
            end
          end,
          ["<Tab>"] = function(fallback)
            if cmp.visible() then
              cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            else
              fallback()
            end
          end,
          ["<S-Tab>"] = function(fallback)
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
            local lspConfig = require('lspconfig')

            lspConfig.omnisharp.setup {
                cmd = { "dotnet", "C:/Users/n.starostin/AppData/Local/nvim-data/mason/packages/omnisharp/libexec/OmniSharp.dll" },
                settings = {
                  FormattingOptions = {
                    -- Enables support for reading code style, naming convention and analyzer
                    -- settings from .editorconfig.
                    EnableEditorConfigSupport = true,
                    -- Specifies whether 'using' directives should be grouped and sorted during
                    -- document formatting.
                    OrganizeImports = nil,
                  },
                  MsBuild = {
                    -- If true, MSBuild project system will only load projects for files that
                    -- were opened in the editor. This setting is useful for big C# codebases
                    -- and allows for faster initialization of code navigation features only
                    -- for projects that are relevant to code that is being edited. With this
                    -- setting enabled OmniSharp may load fewer projects and may thus display
                    -- incomplete reference lists for symbols.
                    LoadProjectsOnDemand = nil,
                  },
                  RoslynExtensionsOptions = {
                    -- Enables support for roslyn analyzers, code fixes and rulesets.
                    EnableAnalyzersSupport = true,
                    -- Enables support for showing unimported types and unimported extension
                    -- methods in completion lists. When committed, the appropriate using
                    -- directive will be added at the top of the current file. This option can
                    -- have a negative impact on initial completion responsiveness,
                    -- particularly for the first few completion sessions after opening a
                    -- solution.
                    EnableImportCompletion = true,
                    -- Only run analyzers against open files when 'enableRoslynAnalyzers' is
                    -- true
                    AnalyzeOpenDocumentsOnly = nil,
                  },
                  Sdk = {
                    -- Specifies whether to include preview versions of the .NET SDK when
                    -- determining which version to use for project loading.
                    IncludePrereleases = true,
                  },
                },
            }

            lspConfig.lua_ls.setup(lua_opts)
            lspConfig.tailwindcss.setup({
              settings = {
                tailwindCSS = {
                  experimental = {
                    classRegex = {
                      "cva\\(([^)]*)\\)",                                      -- Basic cva() pattern
                      "cva\\([\\s\\t]*['\"]([^'\"]*)['\"]",                    -- First string arg
                      -- "['\"`]([^'\"`]*).*?['\"`]\\s*[),]",                     -- Any string in arguments
                      "variants:\\s*{[^}]*\\w+:\\s*['\"]([^'\"]*)['\"]",       -- Variant values
                      "defaultVariants:\\s*{[^}]*\\w+:\\s*['\"]([^'\"]*)['\"]" -- Default variants
                    }
                  },
                  includeLanguages = {
                    typescriptreact = "html",
                    javascriptreact = "html",
                  },
                }
              },
              filetypes = {
                "html",
                "css",
                "javascript",
                "javascriptreact",
                "typescript",
                "typescriptreact",
              },
            })
          end,
        },
      })
    end
  },
}
