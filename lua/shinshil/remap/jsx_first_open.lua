-- Jump straight to the JSX on first open of a React component file.
-- Only capitalized *.tsx (PageLayout.tsx), never lowercase hooks/utils (useThing.ts, api.ts).
-- 1. find `export default`, else `export` (if neither found: leave cursor alone)
-- 2. from there, find the first `return` (the component body) and center it

local group = vim.api.nvim_create_augroup("JsxFirstOpen", { clear = true })

vim.api.nvim_create_autocmd("BufWinEnter", {
  group = group,
  pattern = "*.tsx",
  callback = function(args)
    if vim.b[args.buf].jsx_jumped then return end
    vim.b[args.buf].jsx_jumped = true

    -- skip floating previews (pickers, hovers): jumping there is pointless
    if vim.api.nvim_win_get_config(0).relative ~= "" then return end

    local tail = vim.fn.fnamemodify(args.file, ":t")
    -- capitalized components (PageLayout.tsx) plus lowercase framework
    -- entries that are still components (route.tsx, page.tsx)
    local lower = tail:lower()
    if not tail:match("^[A-Z]") and lower ~= "route.tsx" and lower ~= "page.tsx" then return end

    local old_search = vim.fn.getreg("/")

    -- deterministic start: fresh buffers open at the top anyway
    vim.cmd("keepjumps normal! gg")

    local found = vim.fn.search([[^\s*export\s\+default\>]], "cW")
    if found == 0 then
      found = vim.fn.search([[^\s*export\>]], "cW")
    end
    if found == 0 then
      vim.fn.setreg("/", old_search)
      return -- step 1 failed: don't search for return, don't move
    end

    vim.fn.search([[^\s*return\>]], "W")
    vim.cmd("normal! zz")
    vim.fn.setreg("/", old_search)
  end,
  desc = "Jump to JSX return on first open of a React component",
})
