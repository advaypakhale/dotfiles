return {
    { -- Autocompletion
        "saghen/blink.cmp",
        event = "VimEnter",
        version = "*",
        dependencies = {
            -- Snippet Engine
            {
                "L3MON4D3/LuaSnip",
                version = "2.*",
                build = (function()
                    -- Build Step is needed for regex support in snippets.
                    -- This step is not supported in many windows environments.
                    -- Remove the below condition to re-enable on windows.
                    if
                        vim.fn.has "win32" == 1
                        or vim.fn.executable "make" == 0
                    then
                        return
                    end
                    return "make install_jsregexp"
                end)(),
                dependencies = {
                    {
                        "rafamadriz/friendly-snippets",
                        config = function()
                            require("luasnip.loaders.from_vscode").lazy_load()
                        end,
                    },
                },
                config = function()
                    local luasnip = require "luasnip"
                    local types = require "luasnip.util.types"
                    require("luasnip.loaders.from_vscode").lazy_load {
                        paths = { "./lua/snippets/vscode_snippets" },
                    }
                    -- HACK: Cancel the snippet session when leaving insert mode.
                    vim.api.nvim_create_autocmd("ModeChanged", {
                        group = vim.api.nvim_create_augroup(
                            "UnlinkSnippetOnModeChange",
                            { clear = true }
                        ),
                        pattern = { "s:n", "i:*" },
                        callback = function(event)
                            if
                                luasnip.session
                                and luasnip.session.current_nodes[event.buf]
                                and not luasnip.session.jump_active
                            then
                                luasnip.unlink_current()
                            end
                        end,
                    })
                end,
            },
            "folke/lazydev.nvim",
        },
        --- @module 'blink.cmp'
        --- @type blink.cmp.Config
        opts = {
            keymap = {
                -- 'default' (recommended) for mappings similar to built-in completions
                --   <c-y> to accept ([y]es) the completion.
                --    This will auto-import if your LSP supports it.
                --    This will expand snippets if the LSP sent a snippet.
                -- 'super-tab' for tab to accept
                -- 'enter' for enter to accept
                -- 'none' for no mappings
                --
                -- For an understanding of why the 'default' preset is recommended,
                -- you will need to read `:help ins-completion`
                --
                -- No, but seriously. Please read `:help ins-completion`, it is really good!
                --
                -- All presets have the following mappings:
                -- <tab>/<s-tab>: move to right/left of your snippet expansion
                -- <c-space>: Open menu or open docs if already open
                -- <c-n>/<c-p> or <up>/<down>: Select next/previous item
                -- <c-e>: Hide menu
                -- <c-k>: Toggle signature help
                --
                -- See :h blink-cmp-config-keymap for defining your own keymap
                preset = "none",

                -- super-tab, but also with enter

                ["<C-space>"] = {
                    "show",
                    "show_documentation",
                    "hide_documentation",
                },
                ["<C-e>"] = { "hide", "fallback" },
                ["<CR>"] = { "accept", "fallback" },

                ["<Tab>"] = {
                    function(cmp)
                        if cmp.snippet_active() then
                            return cmp.accept()
                        else
                            return cmp.select_and_accept()
                        end
                    end,
                    "snippet_forward",
                    "fallback",
                },
                ["<S-Tab>"] = { "snippet_backward", "fallback" },

                ["<Up>"] = { "select_prev", "fallback" },
                ["<Down>"] = { "select_next", "fallback" },
                ["<C-p>"] = { "select_prev", "fallback_to_mappings" },
                ["<C-n>"] = { "select_next", "fallback_to_mappings" },

                ["<C-b>"] = { "scroll_documentation_up", "fallback" },
                ["<C-f>"] = { "scroll_documentation_down", "fallback" },

                ["<C-k>"] = { "show_signature", "hide_signature", "fallback" },

                -- For more advanced Luasnip keymaps (e.g. selecting choice nodes, expansion) see:
                --    https://github.com/L3MON4D3/LuaSnip?tab=readme-ov-file#keymaps
            },

            appearance = {
                -- 'mono' (default) for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
                -- Adjusts spacing to ensure icons are aligned
                nerd_font_variant = "mono",
            },

            completion = {
                -- By default, you may press `<c-space>` to show the documentation.
                -- Optionally, set `auto_show = true` to show the documentation after a delay.
                menu = {
                    auto_show = true,
                    -- border = "rounded", -- places too much focus on the completions
                    --     -- nvim-cmp style menu
                    -- draw = {
                    --     columns = {
                    --         { "label", "label_description", gap = 1 },
                    --         { "kind_icon", "kind", gap = 1 },
                    --     },
                    -- }, -- doesn't add much information
                },
                documentation = {
                    auto_show = false, -- quite intrusive if set to true
                    auto_show_delay_ms = 500,
                    -- window = { border = "rounded" },
                },
            },

            sources = {
                default = { "lsp", "path", "snippets", "lazydev" },
                providers = {
                    lazydev = {
                        module = "lazydev.integrations.blink",
                        score_offset = 100,
                    },
                },
            },

            snippets = { preset = "luasnip" },

            -- Blink.cmp includes an optional, recommended rust fuzzy matcher,
            -- which automatically downloads a prebuilt binary when enabled.
            --
            -- By default, we use the Lua implementation instead, but you may enable
            -- the rust implementation via `'prefer_rust_with_warning'`
            --
            -- See :h blink-cmp-config-fuzzy for more information
            fuzzy = { implementation = "rust" },

            -- Shows a signature help window while you type arguments for a function
            signature = { enabled = true },
        },
    },
}
-- vim: ts=2 sts=2 sw=2 et
