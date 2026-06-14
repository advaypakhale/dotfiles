require("lualine").setup {
    options = {
        theme = "tokyonight",
    },
}

-- Watch the shared light/dark state and live-switch open windows (lua/theme.lua).
require("theme").start()
