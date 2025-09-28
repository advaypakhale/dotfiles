return {
    { -- Autoformat
        "stevearc/conform.nvim",
        event = { "BufWritePre" },
        cmd = { "ConformInfo" },
        opts = {
            notify_on_error = false,
            format_on_save = function(bufnr)
                -- Disable "format_on_save lsp_fallback" for languages that don't
                -- have a well standardized coding style. You can add additional
                -- languages here or re-enable it for the disabled ones.
                -- local disable_filetypes = { c = true, cpp = true }

                local disable_filetypes = {
                    python = true, -- disable auto-format via conform for python since we configure ruff LSP to do linting + formatting + organising imports directly
                }

                if disable_filetypes[vim.bo[bufnr].filetype] then
                    return nil
                else
                    return {
                        timeout_ms = 500,
                        lsp_format = "fallback",
                    }
                end
                return {
                    timeout_ms = 500,
                    lsp_format = lsp_format_opt,
                }
            end,
            formatters_by_ft = {
                lua = { "stylua" },
                c = { "clang-format" },
                cpp = { "clang-format" },
                -- use ruff lsp for formatting instead
                -- python = { "ruff_fix", "ruff_format", "ruff_organize_imports" },
                sh = { "shfmt" },
                yaml = { "yamlfmt" },
            },
            formatters = {
                -- C & C++
                ["clang-format"] = {
                    -- prepend_args = {
                    --     "-style={ \
                    --     IndentWidth: 4, \
                    --     TabWidth: 4, \
                    --     UseTab: Never, \
                    --     AccessModifierOffset: 0, \
                    --     IndentAccessModifiers: true, \
                    --     PackConstructorInitializers: Never}",
                    -- },
                },
                -- Lua
                stylua = {
                    prepend_args = {
                        "--column-width",
                        "80",
                        "--line-endings",
                        "Unix",
                        "--indent-type",
                        "Spaces",
                        "--indent-width",
                        "4",
                        "--quote-style",
                        "AutoPreferDouble",
                    },
                },
            },
        },
    },
}
-- vim: ts=2 sts=2 sw=2 et
