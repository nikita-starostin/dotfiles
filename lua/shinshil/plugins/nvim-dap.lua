function FindGlobDirectory(pattern, path)
  local fullpattern = path .. "/" .. pattern
  local target = vim.fn.glob(fullpattern)
  if vim.fn.strlen(target) then
    return target;
  else
    local pathParts = vim.fn.split(path, "/")
    if vim.fn.len(pathParts) then
      local newpath = vim.fn.join(vim.fn.remove(pathParts, -1), "/")
      return FindGlobDirectory(pattern, newpath)
    else
      return 0
    end
  end
end

function GetFileNameWithoutExtension(path)
  return vim.fn.fnamemodify(path, ":t:r")
end

function GetFileDirectory(path)
  return vim.fn.fnamemodify(path, ":h")
end

function GetProjectFrameworkVersion(csprojPath)
  local file = io.open(csprojPath, "r")
  if file then
    local content = file:read("*a")
    file:close()
    local version = string.match(content, "<TargetFramework>(.+)</TargetFramework>")
    return version
  end
  return nil
end

return {
  {
    'mfussenegger/nvim-dap',
    lazy = true,
    event = "BufEnter *.cs",
    dependencies = {
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require('dap')

      dap.adapters.coreclr = {
        type = 'executable',
        command = 'C:\\Users\\n.starostin\\AppData\\Local\\nvim\\netcoredbg\\netcoredbg.exe',
        args = { '--interpreter=vscode' }
      }

      dap.configurations.cs = {
        {
          type = "coreclr",
          name = "launch - netcoredbg",
          request = "launch",
          program = function()
            local nearestCsprojPath = FindGlobDirectory("*.csproj", vim.fn.expand('%:p:h'))
            if nearestCsprojPath == 0 then
              return nil
            end
            local projectDirectory = GetFileDirectory(nearestCsprojPath)
            local projectName = GetFileNameWithoutExtension(nearestCsprojPath)
            local projectFrameworkVersion = GetProjectFrameworkVersion(nearestCsprojPath)
            return projectDirectory .. '/bin/Debug/' .. projectFrameworkVersion .. '/' .. projectName .. '.exe'
          end,
        },
      }

      vim.keymap.set("n", "<F5>", "<Cmd>lua require'dap'.continue()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<F6>", "<Cmd>lua require'dap'.step_over()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<F7>", "<Cmd>lua require'dap'.step_into()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<F8", "<Cmd>lua require'dap'.step_out()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>b", "<Cmd>lua require'dap'.toggle_breakpoint()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>B", "<Cmd>lua require'dap'.set_breakpoint(vim.fn.input('Breakpoint condition: '))<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>lp", "<Cmd>lua require'dap'.set_breakpoint(nil, nil, vim.fn.input('Log point message: '))<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>dr", "<Cmd>lua require'dap'.repl.open()<CR>", { noremap = true, silent = true })
      vim.keymap.set("n", "<Leader>dl", "<Cmd>lua require'dap'.run_last()<CR>", { noremap = true, silent = true })

      local dapui = require('dapui')
      dapui.setup({
        icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
        mappings = {
          -- Use a table to apply multiple mappings
          expand = { "<CR>", "<2-LeftMouse>" },
          open = "o",
          remove = "d",
          edit = "e",
          repl = "r",
          toggle = "t",
        },
        -- Use this to override mappings for specific elements
        element_mappings = {
          -- Example:
          -- stacks = {
          --   open = "<CR>",
          --   expand = "o",
          -- }
        },
        -- Expand lines larger than the window
        -- Requires >= 0.7
        expand_lines = vim.fn.has("nvim-0.7") == 1,
        -- Layouts define sections of the screen to place windows.
        -- The position can be "left", "right", "top" or "bottom".
        -- The size specifies the height/width depending on position. It can be an Int
        -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
        -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
        -- Elements are the elements shown in the layout (in order).
        -- Layouts are opened in order so that earlier layouts take priority in window sizing.
        layouts = {
          {
            elements = {
              -- Elements can be strings or table with id and size keys.
              { id = "scopes", size = 0.25 },
              "breakpoints",
              "stacks",
              "watches",
            },
            size = 40, -- 40 columns
            position = "left",
          },
          {
            elements = {
              "repl",
              "console",
            },
            size = 0.25, -- 25% of total lines
            position = "bottom",
          },
        },
        controls = {
          -- Requires Neovim nightly (or 0.8 when released)
          enabled = true,
          -- Display controls in this element
          element = "repl",
          icons = {
            pause = "",
            play = "",
            step_into = "",
            step_over = "",
            step_out = "",
            step_back = "",
            run_last = "↻",
            terminate = "□",
          },
        },
        floating = {
          max_height = nil, -- These can be integers or a float between 0 and 1.
          max_width = nil, -- Floats will be treated as percentage of your screen.
          border = "single", -- Border style. Can be "single", "double" or "rounded"
          mappings = {
            close = { "q", "<Esc>" },
          },
        },
        windows = { indent = 1 },
        render = {
          max_type_length = nil, -- Can be integer or nil.
          max_value_lines = 100, -- Can be integer or nil.
        }
      })


      dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
      end
      dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
      end
    end
  }
}
