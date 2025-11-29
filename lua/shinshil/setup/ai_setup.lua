require("parrot").setup {
    providers = {
      perplexity = {
        name = "perplexity",
        api_key = os.getenv("PERPLEXITY_API_KEY"),
        endpoint = "https://api.perplexity.ai/chat/completions",
        headers = function(self)
          return {
            ["Content-Type"] = "application/json",
            ["Accept"] = "application/json",
            ["Authorization"] = "Bearer " .. self.api_key,
          }
        end,
        topic = {
          model = "sonar",
          params = {
            max_tokens = 64,
          },
        },
        models = {
          "sonar",
          "sonar-pro",
          "sonar-deep-research",
          "sonar-reasoning",
          "sonar-reasoning-pro",
          "r1-1776",
        },
      }
    },
    hooks = {
      Ask = function(parrot, params)
        local template = [[
          In light of your existing knowledge base, please generate a response that
          is succinct and directly addresses the question posed. Prioritize accuracy
          and relevance in your answer, drawing upon the most recent information
          available to you. Aim to deliver your response in a concise manner,
          focusing on the essence of the inquiry.
          Question: {{command}}
        ]]
        local model_obj = parrot.get_model("command")
        parrot.logger.info("Asking model: " .. model_obj.name)
        parrot.Prompt(params, parrot.ui.Target.popup, model_obj, "🤖 Ask ~ ", template)
      end,
    },
  toggle_target = "popup",
}

vim.api.nvim_create_autocmd("User", {
  pattern = "PrtCancelled",
  callback = function()
    -- Your custom logic here
    print("Parrot generation was cancelled")
  end,
})

-- setup nvim keymaps
vim.keymap.set('n', '<leader>at', ':PrtToggleChat<CR>', { desc = 'Parot - Toggle parrot chat' })
vim.keymap.set('n', '<leader>an', ':PrtNewChat<CR>', { desc = 'Parot - New parrot chat' })
vim.keymap.set('n', '<leader>aii', ':PrtImplement<CR>', { desc = 'Parot - Run parrot implement hook' })
vim.keymap.set('n', '<leader>aa', ':PrtChatRespond<CR>', { desc = 'Parot - Trigger chat respond in current file' })
vim.keymap.set('v', '<leader>ap', ':PrtChatSelection<CR>', { desc = 'Parot - Insert visual selection into latest chat' })
vim.keymap.set('n', '<leader>as', ':PrtSearchChats<CR>', { desc = 'Parot - Search chats' })
vim.keymap.set('v', '<leader>air', ':PrtRewrite<CR>', { desc = 'Parot - Rewrite visual selection with parrot' })
vim.keymap.set('v', '<leader>aia', ':PrtAppend<CR>', { desc = 'Parrot - Append to parrot chat' })
