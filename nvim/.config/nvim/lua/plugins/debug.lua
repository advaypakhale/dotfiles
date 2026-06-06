-- debug.lua
--
-- Shows how to use the DAP plugin to debug your code.
--
-- Generic (language-agnostic) debugger setup. Add language-specific
-- adapters/configs (and their debuggers to mason-nvim-dap) as needed.

local dap = require "dap"
local dapui = require "dapui"

-- Basic debugging keymaps, feel free to change to your liking!
vim.keymap.set("n", "<F5>", function()
    dap.continue()
end, { desc = "Debug: Start/Continue" })
vim.keymap.set("n", "<F1>", function()
    dap.step_into()
end, { desc = "Debug: Step Into" })
vim.keymap.set("n", "<F2>", function()
    dap.step_over()
end, { desc = "Debug: Step Over" })
vim.keymap.set("n", "<F3>", function()
    dap.step_out()
end, { desc = "Debug: Step Out" })
vim.keymap.set("n", "<leader>bb", function()
    dap.toggle_breakpoint()
end, { desc = "Debug: Toggle Breakpoint" })
vim.keymap.set("n", "<leader>bB", function()
    dap.set_breakpoint(vim.fn.input "Breakpoint condition: ")
end, { desc = "Debug: Set Breakpoint" })
-- Toggle to see last session result. Without this, you can't see session output in case of unhandled exception.
vim.keymap.set("n", "<F7>", function()
    dapui.toggle()
end, { desc = "Debug: See last session result." })

require("mason-nvim-dap").setup {
    -- Makes a best effort to setup the various debuggers with
    -- reasonable debug configurations
    automatic_installation = true,

    -- You can provide additional configuration to the handlers,
    -- see mason-nvim-dap README for more information
    handlers = {},

    -- You'll need to check that you have the required things installed
    -- online, please don't ask me how to install them :)
    ensure_installed = {
        -- Update this to ensure that you have the debuggers for the langs you want
    },
}

-- Dap UI setup
-- For more information, see |:help nvim-dap-ui|
dapui.setup {
    -- Set icons to characters that are more likely to work in every terminal.
    --    Feel free to remove or use ones that you like more! :)
    --    Don't feel like these are good choices.
    icons = { expanded = "▾", collapsed = "▸", current_frame = "*" },
    controls = {
        icons = {
            pause = "⏸",
            play = "▶",
            step_into = "⏎",
            step_over = "⏭",
            step_out = "⏮",
            step_back = "b",
            run_last = "▶▶",
            terminate = "⏹",
            disconnect = "⏏",
        },
    },
}

-- Change breakpoint icons
vim.api.nvim_set_hl(0, "DapBreak", { fg = "#e51400" })
vim.api.nvim_set_hl(0, "DapStop", { fg = "#ffcc00" })
local breakpoint_icons = vim.g.have_nerd_font
        and {
            Breakpoint = "",
            BreakpointCondition = "",
            BreakpointRejected = "",
            LogPoint = "",
            Stopped = "",
        }
    or {
        Breakpoint = "●",
        BreakpointCondition = "⊜",
        BreakpointRejected = "⊘",
        LogPoint = "◆",
        Stopped = "⭔",
    }

for type, icon in pairs(breakpoint_icons) do
    local tp = "Dap" .. type
    local hl = (type == "Stopped") and "DapStop" or "DapBreak"
    vim.fn.sign_define(tp, { text = icon, texthl = hl, numhl = hl })
end

dap.listeners.after.event_initialized["dapui_config"] = dapui.open
dap.listeners.before.event_terminated["dapui_config"] = dapui.close
dap.listeners.before.event_exited["dapui_config"] = dapui.close
