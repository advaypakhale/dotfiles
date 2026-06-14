require("tokyonight").setup {
    -- transparent = true,
    -- styles = {
    --     sidebars = "transparent",
    --     floats = "transparent",
    -- },
}

-- Colorscheme follows the shared light/dark state (see lua/theme.lua); applied
-- early here so colors are right before drawing. lualine.lua starts the watcher.
require("theme").apply()
