-- Follows the shared light/dark state at ~/.config/theme/mode (written by the
-- `theme` script) so Neovim stays in sync with Alacritty, live-switching open
-- windows via an fs-event watcher.

local M = {}

local state_file = vim.fn.expand("~/.config/theme/mode")
local schemes = { dark = "tokyonight-night", light = "tokyonight-day" }

function M.read()
    local f = io.open(state_file, "r")
    if not f then
        return "dark"
    end
    local mode = (f:read("l") or ""):gsub("%s+", "")
    f:close()
    return schemes[mode] and mode or "dark"
end

function M.apply(mode)
    mode = mode or M.read()
    vim.cmd.colorscheme(schemes[mode] or schemes.dark)

    -- Re-run setup so lualine regenerates its palette for the new background.
    local ok, lualine = pcall(require, "lualine")
    if ok then
        lualine.setup({ options = { theme = "tokyonight" } })
    end
end

function M.start()
    -- The watcher needs the file to exist before it can attach.
    if vim.fn.filereadable(state_file) == 0 then
        vim.fn.mkdir(vim.fn.fnamemodify(state_file, ":h"), "p")
        local f = io.open(state_file, "w")
        if f then
            f:write("dark\n")
            f:close()
        end
    end

    M.apply()

    local handle = vim.uv.new_fs_event()
    if not handle then
        return
    end
    local function arm()
        handle:start(
            state_file,
            {},
            vim.schedule_wrap(function()
                M.apply()
                handle:stop() -- re-arm in case the file was replaced, not truncated
                arm()
            end)
        )
    end
    arm()
end

return M
