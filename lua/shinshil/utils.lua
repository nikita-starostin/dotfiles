function DebugCurrBuff()
  local values = vim.fn.getbufvar(0, "&")
  for key, value in pairs(values) do
    print(key.." : "..value)
  end
end
