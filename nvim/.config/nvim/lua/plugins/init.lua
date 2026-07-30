-- [[ Plugins ]]
--
-- Managed by `vim.pack` (nvim >= 0.12); versions pinned in nvim-pack-lock.json.
-- Per-plugin config lives in `lua/plugins/<name>.lua`.
--
--  * Update:  `:lua vim.pack.update()`
--  * Remove:  delete it from the list below, then `:lua vim.pack.del({ 'name' })`
--  * Health:  `:checkhealth vim.pack`

-- [[ Install / update hooks ]]
-- Registered before `vim.pack.add()` so they fire on first install too.
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
vim.pack.add({
    -- Colorscheme, added first so it is available before anything draws.
    -- Dark only; light is basic_light in colors/ (see lua/theme.lua).
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
    -- v1 tags ship a prebuilt rust fuzzy binary, so no local cargo build.
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

    -- Remote development
    "https://github.com/advaypakhale/remote.nvim",

    -- Misc (no per-plugin config; loading them is enough)
    "https://github.com/lervag/vimtex",
    "https://github.com/christoomey/vim-tmux-navigator",
})

-- [[ Per-plugin configuration ]]
-- Order matters for setup-time dependencies: mason before its consumers,
-- nvim-lint before mason-nvim-lint.
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
