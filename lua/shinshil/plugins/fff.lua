return {
  -- fast fuzzy file finder, replaces telescope for file picking / grep
  -- to go back to telescope: comment this plugin and uncomment the
  -- file-picking parts in telescope_remap.lua / telescope_setup.lua / init.lua
  {
    "dmtrKovalenko/fff",
    build = function()
      -- downloads a prebuilt binary or falls back to cargo build
      require("fff.download").download_or_build_binary()
    end,
    lazy = false, -- the plugin lazy-initialises its rust backend itself
    config = function()
      require("shinshil.setup.fff_setup")
    end,
  },
}
