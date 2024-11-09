vim.keymap.set("n", "<leader>gb", ":G blame<Cr>", { desc = "Run git fugitive blame for blame view" })
vim.keymap.set("n", "<leader>gs", ":G<Cr>", { desc = "Run git fugitive status" })
vim.keymap.set("n", "<leader>gc", ":G commit<Cr>", { desc = "Run git fugitive commit" })
vim.keymap.set("n", "<leader>gd", ":Gdiffsplit<Cr>", { desc = "Run git fugitive diff view" })
