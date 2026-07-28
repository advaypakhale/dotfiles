require("lualine").setup {
    options = {
        -- Follows the active colorscheme; theme.lua re-applies on every switch.
        theme = "auto",
    },
}

-- Watch the shared light/dark state and live-switch open windows (lua/theme.lua).
require("theme").start()
