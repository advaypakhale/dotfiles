return {
    {
        "folke/snacks.nvim",
        priority = 1000,
        lazy = false,
        ---@type snacks.Config
        opts = {
            bigfile = { enabled = true },
            dashboard = { example = "doom" },
            explorer = { enabled = true },
            input = { enabled = true },
            notifier = {
                enabled = true,
                timeout = 3000,
            },
            picker = { enabled = true },
            quickfile = { enabled = true },
            scope = { enabled = true },
            statuscolumn = { enabled = true },
            words = { enabled = true },
            styles = {
                notification = {
                    -- wo = { wrap = true } -- Wrap notifications
                },
            },
        },
        keys = {
            -- Top Pickers & Explorer
            {
                "<leader>.",
                function()
                    Snacks.picker.smart()
                end,
                desc = "Smart Find Files",
            },
            {
                "<leader><leader>",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>n",
                function()
                    Snacks.picker.notifications()
                end,
                desc = "Notification History",
            },
            {
                "\\",
                function()
                    Snacks.explorer()
                end,
                desc = "File Explorer",
            },
            -- Grep
            {
                "<leader>sB",
                function()
                    Snacks.picker.grep_buffers()
                end,
                desc = "Grep Open Buffers",
            },
            {
                "<leader>sg",
                function()
                    Snacks.picker.grep()
                end,
                desc = "Grep",
            },
            {
                "<leader>sw",
                function()
                    Snacks.picker.grep_word()
                end,
                desc = "Visual selection or word",
                mode = { "n", "x" },
            },
            -- search
            {
                '<leader>s"',
                function()
                    Snacks.picker.registers()
                end,
                desc = "Registers",
            },
            {
                "<leader>s/",
                function()
                    Snacks.picker.search_history()
                end,
                desc = "Search History",
            },
            {
                "<leader>sa",
                function()
                    Snacks.picker.autocmds()
                end,
                desc = "Autocmds",
            },
            {
                "<leader>sb",
                function()
                    Snacks.picker.buffers()
                end,
                desc = "Buffers",
            },
            {
                "<leader>sc",
                function()
                    Snacks.picker.files { cwd = vim.fn.stdpath "config" }
                end,
                desc = "Find Config File",
            },
            {
                "<leader>sC",
                function()
                    Snacks.picker.commands()
                end,
                desc = "Commands",
            },
            {
                "<leader>sd",
                function()
                    Snacks.picker.diagnostics()
                end,
                desc = "Diagnostics",
            },
            {
                "<leader>sD",
                function()
                    Snacks.picker.diagnostics_buffer()
                end,
                desc = "Buffer Diagnostics",
            },
            {
                "<leader>sh",
                function()
                    Snacks.picker.help()
                end,
                desc = "Help Pages",
            },
            {
                "<leader>sH",
                function()
                    Snacks.picker.highlights()
                end,
                desc = "Highlights",
            },
            {
                "<leader>si",
                function()
                    Snacks.picker.icons()
                end,
                desc = "Icons",
            },
            {
                "<leader>sj",
                function()
                    Snacks.picker.jumps()
                end,
                desc = "Jumps",
            },
            {
                "<leader>sk",
                function()
                    Snacks.picker.keymaps()
                end,
                desc = "Keymaps",
            },
            {
                "<leader>sl",
                function()
                    Snacks.picker.loclist()
                end,
                desc = "Location List",
            },
            {
                "<leader>sm",
                function()
                    Snacks.picker.marks()
                end,
                desc = "Marks",
            },
            {
                "<leader>sM",
                function()
                    Snacks.picker.man()
                end,
                desc = "Man Pages",
            },
            {
                "<leader>sp",
                function()
                    Snacks.picker.projects()
                end,
                desc = "Projects",
            },
            {
                "<leader>sq",
                function()
                    Snacks.picker.qflist()
                end,
                desc = "Quickfix List",
            },
            {
                "<leader>sR",
                function()
                    Snacks.picker.resume()
                end,
                desc = "Resume",
            },
            {
                "<leader>su",
                function()
                    Snacks.picker.undo()
                end,
                desc = "Undo History",
            },
            {
                "<leader>tC",
                function()
                    Snacks.picker.colorschemes()
                end,
                desc = "Colorschemes",
            },
            -- Other
            {
                "<leader>tz",
                function()
                    Snacks.zen()
                end,
                desc = "Toggle Zen Mode",
            },
            {
                "<leader>tZ",
                function()
                    Snacks.zen.zoom()
                end,
                desc = "Toggle Zoom",
            },
            {
                "<leader>gB",
                function()
                    Snacks.gitbrowse()
                end,
                desc = "Git Browse",
                mode = { "n", "v" },
            },
            {
                "<leader>gg",
                function()
                    Snacks.lazygit()
                end,
                desc = "Lazygit",
            },
            {
                "<leader>tn",
                function()
                    Snacks.notifier.hide()
                end,
                desc = "Dismiss All Notifications",
            },
            {
                "<c-/>",
                function()
                    Snacks.terminal()
                end,
                desc = "Toggle Terminal",
            },
            {
                "<c-_>",
                function()
                    Snacks.terminal()
                end,
                desc = "which_key_ignore",
            },
            {
                "]]",
                function()
                    Snacks.words.jump(vim.v.count1)
                end,
                desc = "Next Reference",
                mode = { "n", "t" },
            },
            {
                "[[",
                function()
                    Snacks.words.jump(-vim.v.count1)
                end,
                desc = "Prev Reference",
                mode = { "n", "t" },
            },
        },
        init = function()
            vim.api.nvim_create_autocmd("User", {
                pattern = "VeryLazy",
                callback = function()
                    -- Setup some globals for debugging (lazy-loaded)
                    _G.dd = function(...)
                        Snacks.debug.inspect(...)
                    end
                    _G.bt = function()
                        Snacks.debug.backtrace()
                    end
                    vim.print = _G.dd -- Override print to use snacks for `:=` command

                    -- Create some toggle mappings
                    Snacks.toggle
                        .option("spell", { name = "Spelling" })
                        :map "<leader>ts"
                    Snacks.toggle
                        .option("wrap", { name = "Wrap" })
                        :map "<leader>tw"
                    Snacks.toggle
                        .option("relativenumber", { name = "Relative Number" })
                        :map "<leader>tL"
                    Snacks.toggle.diagnostics():map "<leader>td"
                    Snacks.toggle.line_number():map "<leader>tl"
                    Snacks.toggle
                        .option("conceallevel", {
                            off = 0,
                            on = vim.o.conceallevel > 0 and vim.o.conceallevel
                                or 2,
                        })
                        :map "<leader>tc"
                    Snacks.toggle.treesitter():map "<leader>tT"
                    Snacks.toggle
                        .option("background", {
                            off = "light",
                            on = "dark",
                            name = "Dark Background",
                        })
                        :map "<leader>tb"
                    Snacks.toggle.inlay_hints():map "<leader>th"
                    Snacks.toggle.indent():map "<leader>tg"
                    Snacks.toggle.dim():map "<leader>tD"
                end,
            })
        end,
    },
}
