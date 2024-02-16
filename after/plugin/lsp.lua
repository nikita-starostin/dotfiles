local lsp_zero = require('lsp-zero')
 lsp_zero.on_attach(function(client, bufnr)
 -- see :help lsp-zero-keybindings
 -- to learn the available actions
 lsp_zero.default_keymaps({buffer = bufnr})
end)


local cmp = require('cmp')

local function buildCmpFallback(fn)
	return function (fallback)
		if(cmp.visible()) then
			fn()
		else
			fallback()
		end
	end
end

cmp.setup {
	mapping = {
		['<C-h>'] = buildCmpFallback(function ()
			cmp.scroll_docs(-4)
		end),
		['<C-l>'] = buildCmpFallback(function ()
			cmp.scroll_docs(4)
		end),
		['<CR>'] = function(fallback)
			if cmp.visible() then
				cmp.confirm({select = true, behavior = cmp.ConfirmBehavior.Insert})
			else
				fallback()
			end
		end,
		['<Tab>'] = function(fallback)
			if cmp.visible() then
				cmp.confirm({select = true, behavior = cmp.ConfirmBehavior.Replace})
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
	}
}

-- -- to learn how to use mason.nvim with lsp-zero
-- read this: https://github.com/VonHeikemen/lsp-zero.nvim/blob/v3.x/doc/md/guides/integrate-with-mason-nvim.md
require('mason').setup({})
require('mason-lspconfig').setup({
	ensure_installed = {},
	handlers = {
	 lsp_zero.default_setup,
	},
})
