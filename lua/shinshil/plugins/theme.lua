-- START Sync terminal color with nvim color
vim.api.nvim_create_autocmd({ "UIEnter", "ColorScheme" }, {
  callback = function()
    local normal = vim.api.nvim_get_hl(0, { name = "Normal" })
    if not normal.bg then return end
    io.write(string.format("\027]11;#%06x\027\\", normal.bg))
  end,
})

vim.api.nvim_create_autocmd("UILeave", {
  callback = function() io.write("\027]111\027\\") end,
})

-- END sync terminal color with nvim color

-- nice themes
-- zellner light theme
-- slate default for now
-- habamax light theme, should be nice for long coding
-- evening may be nice for light days
-- 'PaperColor' installed
-- cattpuccin installed
-- blue, lightblue - two theme close to turbo pascal
function SetMyTheme(color)
  color = color or "catppuccin-mocha"
  vim.cmd.colorscheme(color)
  -- make the nvim itself 0 opacity, the terminal would be used as background
  -- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
  -- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

-- toggle dark and light theme, has to be here to reference SetMyTheme
vim.keymap.set("n", "<leader>tt", function()
  local currColor = vim.g.colors_name
  if currColor == 'catppuccin-mocha' then
    SetMyTheme('catppuccin-latte')
  else
    SetMyTheme('catppuccin-mocha')
  end
end, { desc = "Toggle dark and light theme" })


return {
  {
    "catppuccin/nvim",
    priority = 990,
    config = function()
      -- thanks to https://github.com/catppuccin/nvim/discussions/323#discussioncomment-5287724
      -- I have a little bit updated to make red less agressive for my eyes in dark and light themes
      require("catppuccin").setup({
        background = {
          light = "latte",
          dark = "mocha",
        },
        color_overrides = {
          latte = {
            rosewater = "#c14a4a",             -- updated by me
            flamingo = "#c14a4a",              -- updated by me
            red = "#a37827",                   -- updated by me
            maroon = "#a37827",                -- updated by me
            pink = "#945e80",
            mauve = "#945e80",
            peach = "#c35e0a",
            yellow = "#b47109",
            green = "#6c782e",
            teal = "#4c7a5d",
            sky = "#4c7a5d",
            sapphire = "#4c7a5d",
            blue = "#45707a",
            lavender = "#45707a",
            text = "#654735",
            subtext1 = "#73503c",
            subtext0 = "#805942",
            overlay2 = "#8c6249",
            overlay1 = "#8c856d",
            overlay0 = "#a69d81",
            surface2 = "#bfb695",
            surface1 = "#d1c7a3",
            surface0 = "#e3dec3",
            base = "#f9f5d7",
            mantle = "#f0ebce",
            crust = "#e8e3c8",
          },
          mocha = {
            rosewater = "#D67A6E", -- muted coral: errors, distinct from amber keywords
            flamingo = "#D67A6E",
            red = "#D49A45",       -- keywords: warm amber
            maroon = "#D49A45",
            pink = "#D783A2",      -- booleans/constants: soft pink
            mauve = "#D783A2",
            peach = "#D49A45",     -- warnings / Git change: amber
            yellow = "#C79AC3",    -- types/interfaces: restrained pink-purple
            green = "#A6B96C",     -- components/classes: yellow-green
            teal = "#D8BD7A",      -- strings: muted gold
            sky = "#79BFC4",       -- functions/method calls: cyan
            sapphire = "#79BFC4",
            blue = "#92A0B3",      -- properties/object keys: blue-gray
            lavender = "#C79AC3",  -- types for integrations
            text = "#D3D0C6",      -- default fg: warm ivory, softer than white
            subtext1 = "#B8B5AB",
            subtext0 = "#8F8C84",
            overlay2 = "#84908A",  -- operators/punctuation
            overlay1 = "#707A75",  -- delimiters, dimmer punctuation
            overlay0 = "#4D5754",  -- LineNr dim
            surface2 = "#354044",  -- selection
            surface1 = "#2D3436",
            surface0 = "#23292A",  -- cursorline
            base = "#1B1F20",      -- warm graphite background
            mantle = "#1F2425",    -- floats/sidebars, almost same as base
            crust = "#161A1B",
          },
        },
        transparent_background = false,
        show_end_of_buffer = false,
        integration_default = false,
        integrations = {
          barbecue = { dim_dirname = true, bold_basename = true, dim_context = false, alt_background = false },
          cmp = true,
          gitsigns = true,
          hop = true,
          illuminate = { enabled = true },
          native_lsp = { enabled = true, inlay_hints = { background = true } },
          neogit = true,
          neotree = true,
          semantic_tokens = true,
          treesitter = true,
          treesitter_context = true,
          vimwiki = true,
          which_key = true,
        },
        highlight_overrides = {
          all = function(colors)
            return {
              CmpItemMenu = { fg = colors.overlay2 },
              Comment = { fg = "#6E7874", style = { "italic" } },
              CursorLine = { bg = colors.surface0 },
              CursorLineNr = { fg = colors.teal, style = { "bold" } },
              FloatBorder = { bg = colors.mantle, fg = colors.surface1 },
              OilFloatBorder = { bg = colors.mantle, fg = colors.overlay1 },
              GitSignsAdd = { fg = "#86B89A" },
              GitSignsChange = { fg = colors.peach },
              GitSignsDelete = { fg = colors.rosewater },
              LineNr = { fg = colors.overlay0 },
              LspInfoBorder = { link = "FloatBorder" },
              NeoTreeDirectoryIcon = { fg = colors.subtext1 },
              NeoTreeDirectoryName = { fg = colors.subtext1 },
              NeoTreeFloatBorder = { link = "TelescopeResultsBorder" },
              NeoTreeGitConflict = { fg = colors.rosewater },
              NeoTreeGitDeleted = { fg = colors.rosewater },
              NeoTreeGitIgnored = { fg = colors.overlay0 },
              NeoTreeGitModified = { fg = colors.peach },
              NeoTreeGitStaged = { fg = "#86B89A" },
              NeoTreeGitUnstaged = { fg = colors.rosewater },
              NeoTreeGitUntracked = { fg = "#86B89A" },
              NeoTreeIndent = { fg = colors.surface1 },
              NeoTreeNormal = { bg = colors.mantle },
              NeoTreeNormalNC = { bg = colors.mantle },
              NeoTreeRootName = { fg = colors.subtext1, style = { "bold" } },
              NeoTreeTabActive = { fg = colors.text, bg = colors.mantle },
              NeoTreeTabInactive = { fg = colors.surface2, bg = colors.crust },
              NeoTreeTabSeparatorActive = { fg = colors.mantle, bg = colors.mantle },
              NeoTreeTabSeparatorInactive = { fg = colors.crust, bg = colors.crust },
              NeoTreeWinSeparator = { fg = colors.base, bg = colors.base },
              NormalFloat = { fg = colors.text, bg = colors.mantle },
              Visual = { bg = colors.surface2 },
              diffAdded = { fg = "#86B89A" },
              diffRemoved = { fg = colors.rosewater },
              DiagnosticError = { fg = colors.rosewater },
              DiagnosticWarn = { fg = colors.peach },
              DiagnosticInfo = { fg = colors.sky },
              DiagnosticHint = { fg = "#86B89A" },
              Pmenu = { bg = colors.mantle, fg = "" },
              PmenuSel = { bg = colors.surface0, fg = "" },
              TelescopePreviewBorder = { bg = colors.crust, fg = colors.crust },
              TelescopePreviewNormal = { bg = colors.crust },
              TelescopePreviewTitle = { fg = colors.crust, bg = colors.crust },
              TelescopePromptBorder = { bg = colors.surface0, fg = colors.surface0 },
              TelescopePromptCounter = { fg = colors.mauve, style = { "bold" } },
              TelescopePromptNormal = { bg = colors.surface0 },
              TelescopePromptPrefix = { bg = colors.surface0 },
              TelescopePromptTitle = { fg = colors.surface0, bg = colors.surface0 },
              TelescopeResultsBorder = { bg = colors.mantle, fg = colors.mantle },
              TelescopeResultsNormal = { bg = colors.mantle },
              TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
              TelescopeSelection = { bg = colors.surface0 },
              VertSplit = { bg = colors.base, fg = colors.surface0 },
              WhichKeyFloat = { bg = colors.mantle },
              YankHighlight = { bg = colors.surface2 },
              FidgetTask = { fg = colors.subtext0 },
              FidgetTitle = { fg = colors.peach },

              IblIndent = { fg = colors.surface0 },
              IblScope = { fg = colors.overlay0 },

              Boolean = { fg = colors.mauve },
              Number = { fg = colors.mauve },
              Float = { fg = colors.mauve },

              PreProc = { fg = colors.mauve },
              PreCondit = { fg = colors.mauve },
              Include = { fg = colors.mauve },
              Define = { fg = colors.mauve },
              Conditional = { fg = colors.red },
              Repeat = { fg = colors.red },
              Keyword = { fg = colors.red },
              Typedef = { fg = colors.red },
              Exception = { fg = colors.red },
              Statement = { fg = colors.red },

              Error = { fg = colors.rosewater },
              StorageClass = { fg = colors.peach },
              Tag = { fg = "#87AFA6" },
              Label = { fg = colors.peach },
              Structure = { fg = colors.peach },
              Operator = { fg = colors.overlay2 },
              Title = { fg = colors.peach },
              Special = { fg = colors.teal },
              SpecialChar = { fg = colors.teal },
              Type = { fg = colors.yellow },
              Function = { fg = colors.sky },
              Delimiter = { fg = colors.overlay1 },
              Ignore = { fg = colors.overlay0 },
              Macro = { fg = colors.sky },

              TSAnnotation = { fg = colors.mauve },
              TSAttribute = { fg = colors.mauve },
              TSBoolean = { fg = colors.mauve },
              TSCharacter = { fg = colors.teal },
              TSCharacterSpecial = { link = "SpecialChar" },
              TSComment = { link = "Comment" },
              TSConditional = { fg = colors.red },
              TSConstBuiltin = { fg = colors.mauve },
              TSConstMacro = { fg = colors.mauve },
              TSConstant = { fg = colors.text },
              TSConstructor = { fg = colors.green },
              TSDebug = { link = "Debug" },
              TSDefine = { link = "Define" },
              TSEnvironment = { link = "Macro" },
              TSEnvironmentName = { link = "Type" },
              TSError = { link = "Error" },
              TSException = { fg = colors.red },
              TSField = { fg = colors.blue },
              TSFloat = { fg = colors.mauve },
              TSFuncBuiltin = { fg = colors.sky },
              TSFuncMacro = { fg = colors.sky },
              TSFunction = { fg = colors.sky },
              TSFunctionCall = { fg = colors.sky },
              TSInclude = { fg = colors.red },
              TSKeyword = { fg = colors.red },
              TSKeywordFunction = { fg = colors.red },
              TSKeywordOperator = { fg = colors.overlay2 },
              TSKeywordReturn = { fg = colors.red },
              TSLabel = { fg = colors.peach },
              TSLiteral = { link = "String" },
              TSMath = { fg = colors.blue },
              TSMethod = { fg = colors.sky },
              TSMethodCall = { fg = colors.sky },
              TSNamespace = { fg = colors.yellow },
              TSNone = { fg = colors.text },
              TSNumber = { fg = colors.mauve },
              TSOperator = { fg = colors.overlay2 },
              TSParameter = { fg = colors.text },
              TSParameterReference = { fg = colors.text },
              TSPreProc = { link = "PreProc" },
              TSProperty = { fg = colors.blue },
              TSPunctBracket = { fg = colors.overlay2 },
              TSPunctDelimiter = { fg = colors.overlay1 },
              TSPunctSpecial = { fg = colors.overlay2 },
              TSRepeat = { fg = colors.red },
              TSStorageClass = { fg = colors.peach },
              TSStorageClassLifetime = { fg = colors.peach },
              TSStrike = { fg = colors.overlay0 },
              TSString = { fg = colors.teal },
              TSStringEscape = { fg = colors.sky },
              TSStringRegex = { fg = "#86B89A" },
              TSStringSpecial = { link = "SpecialChar" },
              TSSymbol = { fg = colors.text },
              TSTag = { fg = "#87AFA6" },
              TSTagAttribute = { fg = colors.blue },
              TSTagDelimiter = { fg = colors.overlay2 },
              TSText = { fg = colors.text },
              TSTextReference = { link = "Constant" },
              TSTitle = { link = "Title" },
              TSTodo = { link = "Todo" },
              TSType = { fg = colors.yellow },
              TSTypeBuiltin = { fg = colors.yellow },
              TSTypeDefinition = { fg = colors.yellow },
              TSTypeQualifier = { fg = colors.peach },
              TSURI = { fg = colors.sky },
              TSVariable = { fg = colors.text },
              TSVariableBuiltin = { fg = colors.mauve },

              ["@annotation"] = { link = "TSAnnotation" },
              ["@attribute"] = { link = "TSAttribute" },
              ["@boolean"] = { link = "TSBoolean" },
              ["@character"] = { link = "TSCharacter" },
              ["@character.special"] = { link = "TSCharacterSpecial" },
              ["@comment"] = { link = "TSComment" },
              ["@conceal"] = { link = "Ignore" },
              ["@conditional"] = { link = "TSConditional" },
              ["@constant"] = { link = "TSConstant" },
              ["@constant.builtin"] = { link = "TSConstBuiltin" },
              ["@constant.macro"] = { link = "TSConstMacro" },
              ["@constructor"] = { link = "TSConstructor" },
              ["@debug"] = { link = "TSDebug" },
              ["@define"] = { link = "TSDefine" },
              ["@error"] = { link = "TSError" },
              ["@exception"] = { link = "TSException" },
              ["@field"] = { link = "TSField" },
              ["@float"] = { link = "TSFloat" },
              ["@function"] = { link = "TSFunction" },
              ["@function.builtin"] = { link = "TSFuncBuiltin" },
              ["@function.call"] = { link = "TSFunctionCall" },
              ["@function.macro"] = { link = "TSFuncMacro" },
              ["@include"] = { link = "TSInclude" },
              ["@keyword"] = { link = "TSKeyword" },
              ["@keyword.function"] = { link = "TSKeywordFunction" },
              ["@keyword.operator"] = { link = "TSKeywordOperator" },
              ["@keyword.return"] = { link = "TSKeywordReturn" },
              ["@label"] = { link = "TSLabel" },
              ["@math"] = { link = "TSMath" },
              ["@method"] = { link = "TSMethod" },
              ["@method.call"] = { link = "TSMethodCall" },
              ["@namespace"] = { link = "TSNamespace" },
              ["@none"] = { link = "TSNone" },
              ["@number"] = { link = "TSNumber" },
              ["@operator"] = { link = "TSOperator" },
              ["@parameter"] = { link = "TSParameter" },
              ["@parameter.reference"] = { link = "TSParameterReference" },
              ["@preproc"] = { link = "TSPreProc" },
              ["@property"] = { link = "TSProperty" },
              ["@punctuation.bracket"] = { link = "TSPunctBracket" },
              ["@punctuation.delimiter"] = { link = "TSPunctDelimiter" },
              ["@punctuation.special"] = { link = "TSPunctSpecial" },
              ["@repeat"] = { link = "TSRepeat" },
              ["@storageclass"] = { link = "TSStorageClass" },
              ["@storageclass.lifetime"] = { link = "TSStorageClassLifetime" },
              ["@strike"] = { link = "TSStrike" },
              ["@string"] = { link = "TSString" },
              ["@string.escape"] = { link = "TSStringEscape" },
              ["@string.regex"] = { link = "TSStringRegex" },
              ["@string.special"] = { link = "TSStringSpecial" },
              ["@symbol"] = { link = "TSSymbol" },
              ["@tag"] = { link = "TSTag" },
              ["@tag.attribute"] = { link = "TSTagAttribute" },
              ["@tag.delimiter"] = { link = "TSTagDelimiter" },
              ["@text"] = { link = "TSText" },
              ["@text.danger"] = { link = "TSDanger" },
              ["@text.diff.add"] = { link = "diffAdded" },
              ["@text.diff.delete"] = { link = "diffRemoved" },
              ["@text.emphasis"] = { link = "TSEmphasis" },
              ["@text.environment"] = { link = "TSEnvironment" },
              ["@text.environment.name"] = { link = "TSEnvironmentName" },
              ["@text.literal"] = { link = "TSLiteral" },
              ["@text.math"] = { link = "TSMath" },
              ["@text.note"] = { link = "TSNote" },
              ["@text.reference"] = { link = "TSTextReference" },
              ["@text.strike"] = { link = "TSStrike" },
              ["@text.strong"] = { link = "TSStrong" },
              ["@text.title"] = { link = "TSTitle" },
              ["@text.todo"] = { link = "TSTodo" },
              ["@text.todo.checked"] = { link = "diffAdded" },
              ["@text.todo.unchecked"] = { link = "Ignore" },
              ["@text.underline"] = { link = "TSUnderline" },
              ["@text.uri"] = { link = "TSURI" },
              ["@text.warning"] = { link = "TSWarning" },
              ["@todo"] = { link = "TSTodo" },
              ["@type"] = { link = "TSType" },
              ["@type.builtin"] = { link = "TSTypeBuiltin" },
              ["@type.definition"] = { link = "TSTypeDefinition" },
              ["@type.qualifier"] = { link = "TSTypeQualifier" },
              ["@uri"] = { link = "TSURI" },
              ["@variable"] = { link = "TSVariable" },
              ["@variable.builtin"] = { link = "TSVariableBuiltin" },
              ["@variable.member"] = { link = "TSProperty" },
              ["@variable.parameter"] = { link = "TSParameter" },
              ["@module"] = { link = "TSNamespace" },

              ["@lsp.type.class"] = { link = "TSType" },
              ["@lsp.type.comment"] = { link = "TSComment" },
              ["@lsp.type.decorator"] = { link = "TSFunction" },
              ["@lsp.type.enum"] = { link = "TSType" },
              ["@lsp.type.enumMember"] = { link = "TSProperty" },
              ["@lsp.type.events"] = { link = "TSLabel" },
              ["@lsp.type.function"] = { link = "TSFunction" },
              ["@lsp.type.interface"] = { link = "TSType" },
              ["@lsp.type.keyword"] = { link = "TSKeyword" },
              ["@lsp.type.macro"] = { link = "TSConstMacro" },
              ["@lsp.type.method"] = { link = "TSMethod" },
              ["@lsp.type.modifier"] = { link = "TSTypeQualifier" },
              ["@lsp.type.namespace"] = { link = "TSNamespace" },
              ["@lsp.type.number"] = { link = "TSNumber" },
              ["@lsp.type.operator"] = { link = "TSOperator" },
              ["@lsp.type.parameter"] = { link = "TSParameter" },
              ["@lsp.type.property"] = { link = "TSProperty" },
              ["@lsp.type.regexp"] = { link = "TSStringRegex" },
              ["@lsp.type.string"] = { link = "TSString" },
              ["@lsp.type.struct"] = { link = "TSType" },
              ["@lsp.type.type"] = { link = "TSType" },
              ["@lsp.type.typeParameter"] = { link = "TSTypeDefinition" },
              ["@lsp.type.variable"] = { link = "TSVariable" },
            }
          end,
          latte = function(colors)
            return {
              IblIndent = { fg = colors.mantle },
              IblScope = { fg = colors.surface1 },

              LineNr = { fg = colors.surface1 },
            }
          end,
        },
      })
      SetMyTheme()
    end
  }
}
