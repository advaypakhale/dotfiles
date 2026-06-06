-- Highlight, edit, and navigate code.
--
-- nvim-treesitter `main` branch (the rewrite). Parsers are installed via
-- `install()`, and highlighting/indentation are enabled per buffer via a
-- FileType autocmd. Compiling parsers needs the `tree-sitter` CLI + a C
-- compiler (see scripts/install_nvim.sh). Parser updates run from the
-- `PackChanged` hook (`:TSUpdate`) in `lua/plugins/init.lua`.

local ts = require "nvim-treesitter"

-- Core parsers installed eagerly at startup so common filetypes never wait on
-- first open. Any *other* parser is auto-installed on demand by the FileType
-- autocmd below, so this list only needs the languages you hit constantly.
ts.install {
    -- Languages I use
    "bash",
    "python",
    "java",
    "xml",
    "html",
    "css",
    "markdown",
    "markdown_inline", -- inline highlighting (code spans, links) inside markdown
    "proto", -- protobuf
    "yaml",
    "c",
    "cpp",
    "rust",
    "go",
    "gomod",
    "gosum",
    "javascript", -- also handles .jsx
    "typescript", -- .ts
    "tsx", -- .tsx
    "lua",
    "luadoc", -- ---@param etc. annotations
    "latex",
    "make", -- makefiles
    "cmake",
    -- Neovim essentials (editing this config, reading :help, git)
    "vim",
    "vimdoc",
    "query",
    "diff",
    -- Broadly useful
    "json",
    "toml",
    "dockerfile",
    "regex",
    "gitcommit",
    "gitignore",
    "git_config",
    "git_rebase",
}

-- Filetypes for which treesitter indentation (experimental) is *not* used.
local no_indent = { ruby = true }

-- Attach treesitter highlighting (and, when available, indentation) to a buffer.
local function try_attach(buf, ft, lang)
    -- Only proceed if a parser for this language is actually available.
    local ok, added = pcall(vim.treesitter.language.add, lang)
    if not (ok and added) then
        return
    end

    -- Highlighting
    vim.treesitter.start(buf)

    -- Indentation (experimental on the main branch). Only set indentexpr
    -- when the parser actually ships an `indents` query, otherwise fall
    -- back to Vim's built-in indenting instead of a no-op indentexpr.
    if not no_indent[ft] and vim.treesitter.query.get(lang, "indents") ~= nil then
        vim.bo[buf].indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end
end

-- Every parser nvim-treesitter knows how to build (queried once at startup).
local available_parsers = ts.get_available()

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter-enable", { clear = true }),
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
            return
        end

        local installed = ts.get_installed "parsers"
        if vim.tbl_contains(installed, lang) then
            -- Parser already installed: attach immediately.
            try_attach(ev.buf, ft, lang)
        elseif vim.tbl_contains(available_parsers, lang) then
            -- Parser is buildable but missing: install it asynchronously,
            -- then attach once the build finishes.
            ts.install(lang):await(function()
                try_attach(ev.buf, ft, lang)
            end)
        else
            -- Not a nvim-treesitter parser, but a parser may still exist on
            -- the runtimepath (e.g. shipped with Neovim) — try anyway.
            try_attach(ev.buf, ft, lang)
        end
    end,
})
