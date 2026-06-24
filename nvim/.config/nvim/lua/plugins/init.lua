-- [[ Plugins ]]
--
-- Managed by `vim.pack`, Neovim's built-in plugin manager (requires >= 0.12).
--
-- Best practices followed here (see https://echasnovski.com/blog/2026-03-13-a-guide-to-vim-pack):
--  * A single `vim.pack.add()` lists every plugin -> acts as a complete blueprint
--    and makes bootstrapping on a fresh machine trivial.
--  * Install/update hooks are registered (via the `PackChanged` autocmd) *before*
--    `vim.pack.add()` runs, so they fire correctly on first install.
--  * Per-plugin configuration lives in its own module under `lua/plugins/<name>.lua`
--    and is `require`d after the add.
--
-- Plugin housekeeping (no manager UI to memorise):
--  * Update:  `:lua vim.pack.update()`   (interactive confirm buffer)
--  * Remove:  delete it from the list below, then `:lua vim.pack.del({ 'name' })`
--  * Health:  `:checkhealth vim.pack`
-- The `nvim-pack-lock.json` lockfile (committed to this repo) pins exact versions.

-- [[ Install / update hooks ]]
-- Registered before `vim.pack.add()` so they run on the very first install too.
vim.api.nvim_create_autocmd("PackChanged", {
    group = vim.api.nvim_create_augroup("pack-hooks", { clear = true }),
    callback = function(ev)
        local name = ev.data.spec and ev.data.spec.name
        local kind = ev.data.kind
        if kind ~= "install" and kind ~= "update" then
            return
        end

        -- Compile/update Tree-sitter parsers after the plugin changes.
        if name == "nvim-treesitter" then
            if not ev.data.active then
                vim.cmd.packadd("nvim-treesitter")
            end
            vim.cmd("TSUpdate")

        -- Build LuaSnip's optional jsregexp for regex support in snippets.
        elseif name == "LuaSnip" then
            if vim.fn.executable("make") == 1 and ev.data.path then
                vim.system(
                    { "make", "install_jsregexp" },
                    { cwd = ev.data.path }
                )
            end
        end
    end,
})

-- [[ Plugin list ]]
-- Loaded immediately (no lazy loading by design). The lockfile tracks versions;
-- add a `version` field to any entry to pin a branch/tag/semver range, e.g.
--   { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1") }
vim.pack.add({
    -- Colorscheme (added first so it is available before anything draws).
    "https://github.com/folke/tokyonight.nvim",

    -- UI / pickers / editing
    "https://github.com/folke/snacks.nvim",
    "https://github.com/nvim-mini/mini.nvim",
    "https://github.com/nvim-lualine/lualine.nvim",
    "https://github.com/folke/which-key.nvim",
    "https://github.com/NMAC427/guess-indent.nvim",
    "https://github.com/stevearc/oil.nvim",
    "https://github.com/folke/trouble.nvim",

    -- Tree-sitter (`main` branch, the default). Compiles parsers via the
    -- `tree-sitter` CLI + a C compiler (installed by scripts/install_nvim.sh).
    "https://github.com/nvim-treesitter/nvim-treesitter",

    -- LSP + completion
    "https://github.com/neovim/nvim-lspconfig",
    "https://github.com/mason-org/mason.nvim",
    "https://github.com/mason-org/mason-lspconfig.nvim",
    "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim",
    "https://github.com/folke/lazydev.nvim",
    -- Pinned to the v1 release line: tagged releases ship a prebuilt rust fuzzy
    -- binary (no local cargo build), and v1 does not need the separate blink.lib
    -- that the in-development v2 (`main`) requires.
    { src = "https://github.com/saghen/blink.cmp", version = vim.version.range("1.*") },
    "https://github.com/L3MON4D3/LuaSnip",
    "https://github.com/rafamadriz/friendly-snippets",

    -- Formatting + linting
    "https://github.com/stevearc/conform.nvim",
    "https://github.com/zapling/mason-conform.nvim",
    "https://github.com/mfussenegger/nvim-lint",
    "https://github.com/rshkarin/mason-nvim-lint",

    -- Git
    "https://github.com/lewis6991/gitsigns.nvim",
    "https://github.com/esmuellert/codediff.nvim", -- VSCode-style diff, `:CodeDiff`

    -- Debugging (DAP)
    "https://github.com/mfussenegger/nvim-dap",
    "https://github.com/rcarriga/nvim-dap-ui",
    "https://github.com/nvim-neotest/nvim-nio",
    "https://github.com/jay-babu/mason-nvim-dap.nvim",

    -- Misc (no per-plugin config; loading them is enough)
    "https://github.com/advaypakhale/remote.nvim",
    "https://github.com/lervag/vimtex",
    "https://github.com/christoomey/vim-tmux-navigator",
})

-- [[ Per-plugin configuration ]]
-- Order matters only for setup-time dependencies (e.g. mason before its consumers,
-- nvim-lint before mason-nvim-lint), not for plugin availability.
require "plugins.tokyonight"
require "plugins.snacks"
require "plugins.mini"
require "plugins.treesitter"
require "plugins.lspconfig"
require "plugins.blink"
require "plugins.conform"
require "plugins.mason-conform"
require "plugins.lint"
require "plugins.mason-lint"
require "plugins.git"
require "plugins.lualine"
require "plugins.oil"
require "plugins.trouble"
require "plugins.which-key"
require "plugins.guess-indent"
require "plugins.debug"
require "plugins.remote"
