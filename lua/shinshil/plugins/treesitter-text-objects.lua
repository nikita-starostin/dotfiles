return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      require("nvim-treesitter-textobjects").setup({
        select = {
          -- Automatically jump forward to textobj, similar to targets.vim
          lookahead = true,
        },
        move = {
          set_jumps = true, -- whether to set jumps in the jumplist
        },
      })

      local select = require("nvim-treesitter-textobjects.select")
      local move = require("nvim-treesitter-textobjects.move")
      local swap = require("nvim-treesitter-textobjects.swap")

      -- select textobjects
      local select_keymaps = {
        { "a=", "@assignment.outer", "Select outer part of an assignment" },
        { "i=", "@assignment.inner", "Select inner part of an assignment" },
        { "l=", "@assignment.lhs", "Select left hand side of an assignment" },
        { "r=", "@assignment.rhs", "Select right hand side of an assignment" },
        { "a:", "@property.outer", "Select outer part of an object property" },
        { "i:", "@property.inner", "Select inner part of an object property" },
        { "l:", "@property.lhs", "Select left part of an object property" },
        { "r:", "@property.rhs", "Select right part of an object property" },
        { "aa", "@parameter.outer", "Select outer part of a parameter/argument" },
        { "ia", "@parameter.inner", "Select inner part of a parameter/argument" },
        { "ai", "@conditional.outer", "Select outer part of a conditional" },
        { "ii", "@conditional.inner", "Select inner part of a conditional" },
        { "al", "@loop.outer", "Select outer part of a loop" },
        { "il", "@loop.inner", "Select inner part of a loop" },
        { "af", "@call.outer", "Select outer part of a function call" },
        { "if", "@call.inner", "Select inner part of a function call" },
        { "am", "@function.outer", "Select outer part of a method/function definition" },
        { "im", "@function.inner", "Select inner part of a method/function definition" },
        { "ac", "@class.outer", "Select outer part of a class" },
        { "ic", "@class.inner", "Select inner part of a class" },
      }
      for _, m in ipairs(select_keymaps) do
        local query = m[2]
        vim.keymap.set({ "x", "o" }, m[1], function()
          select.select_textobject(query, "textobjects")
        end, { desc = m[3] })
      end

      -- swap textobjects
      local swap_next = {
        { "<leader>na", "@parameter.inner" },
        { "<leader>n:", "@property.outer" },
        { "<leader>nm", "@function.outer" },
      }
      local swap_previous = {
        { "<leader>pa", "@parameter.inner" },
        { "<leader>p:", "@property.outer" },
        { "<leader>pm", "@function.outer" },
      }
      for _, m in ipairs(swap_next) do
        local query = m[2]
        vim.keymap.set("n", m[1], function()
          swap.swap_next(query)
        end)
      end
      for _, m in ipairs(swap_previous) do
        local query = m[2]
        vim.keymap.set("n", m[1], function()
          swap.swap_previous(query)
        end)
      end

      -- move textobjects
      local move_next_start = {
        { "]f", "@call.outer", "Next function call start" },
        { "]m", "@function.outer", "Next method/function def start" },
        { "]c", "@class.outer", "Next class start" },
        { "]i", "@conditional.outer", "Next conditional start" },
        { "]l", "@loop.outer", "Next loop start" },
        { "]s", "@local.scope", "Next scope", "locals" },
        { "]z", "@fold", "Next fold", "folds" },
      }
      local move_next_end = {
        { "]F", "@call.outer", "Next function call end" },
        { "]M", "@function.outer", "Next method/function def end" },
        { "]C", "@class.outer", "Next class end" },
        { "]I", "@conditional.outer", "Next conditional end" },
        { "]L", "@loop.outer", "Next loop end" },
      }
      local move_prev_start = {
        { "[f", "@call.outer", "Prev function call start" },
        { "[m", "@function.outer", "Prev method/function def start" },
        { "[c", "@class.outer", "Prev class start" },
        { "[i", "@conditional.outer", "Prev conditional start" },
        { "[l", "@loop.outer", "Prev loop start" },
      }
      local move_prev_end = {
        { "[F", "@call.outer", "Prev function call end" },
        { "[M", "@function.outer", "Prev method/function def end" },
        { "[C", "@class.outer", "Prev class end" },
        { "[I", "@conditional.outer", "Prev conditional end" },
        { "[L", "@loop.outer", "Prev loop end" },
      }
      for _, m in ipairs(move_next_start) do
        local query = m[2]
        local group = m[4] or "textobjects"
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          move.goto_next_start(query, group)
        end, { desc = m[3] })
      end
      for _, m in ipairs(move_next_end) do
        local query = m[2]
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          move.goto_next_end(query, "textobjects")
        end, { desc = m[3] })
      end
      for _, m in ipairs(move_prev_start) do
        local query = m[2]
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          move.goto_previous_start(query, "textobjects")
        end, { desc = m[3] })
      end
      for _, m in ipairs(move_prev_end) do
        local query = m[2]
        vim.keymap.set({ "n", "x", "o" }, m[1], function()
          move.goto_previous_end(query, "textobjects")
        end, { desc = m[3] })
      end
    end,
  }
}
