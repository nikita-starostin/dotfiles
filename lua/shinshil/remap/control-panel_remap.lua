-- Control panel ("gb" / "gbr").
--
-- "gb" shows the control panel (neo-tree "activities" source) if nothing
-- follows within 200ms. "gbr" runs the CLI to refresh the board instead.
-- Mirrors the 'd' watch in plugins/oil.lua.

local gb = { pending = false, timer = nil, saw_g = false }
local gb_ns = vim.api.nvim_create_namespace("control_panel_gb")

local function cancel_gb()
  gb.pending = false
  if gb.timer then
    gb.timer:stop()
    gb.timer:close()
    gb.timer = nil
  end
end

local function open_panel()
  require("activity_board").open()
end

local function refresh_board()
  require("activity_board").sync()
end

vim.on_key(function(char, typed)
  if not typed then
    return
  end
  if vim.fn.mode() ~= "n" then
    gb.saw_g = false
    cancel_gb()
    return
  end
  if char == "g" then
    -- a second "g" is "gg", a different command; reset the flag
    gb.saw_g = not gb.saw_g
    return
  end
  if char == "b" and gb.saw_g then
    gb.saw_g = false
    if gb.pending then
      cancel_gb()
      return
    end
    gb.pending = true
    gb.timer = vim.uv.new_timer()
    gb.timer:start(200, 0, vim.schedule_wrap(function()
      if not gb.pending then
        return
      end
      cancel_gb()
      open_panel()
    end))
    return
  end
  if char == "r" and gb.pending then
    cancel_gb()
    refresh_board()
    return
  end
  if gb.pending then
    cancel_gb()
  end
  gb.saw_g = false
end, gb_ns)

-- NOTE: "gb"/"gbr" are intentionally NOT mapped. Mapping "g" to a Lua
-- function makes Neovim report the key to vim.on_key as a K_SPECIAL-encoded
-- sequence instead of the plain "g"/"b", which would break the detection
-- above. Unmapped, a stray "g"+"b" is harmless: "g" consumes "b" as an
-- invalid prefix command, so no cursor movement occurs.
