-- Highlight, edit, and navigate code.
--
-- nvim-treesitter `main` branch (the rewrite). Parsers are installed via
-- `install()`, and highlighting/indentation are enabled per buffer via a
-- FileType autocmd. Compiling parsers needs the `tree-sitter` CLI + a C
-- compiler (see scripts/install_nvim.sh). Parser updates run from the
-- `PackChanged` hook (`:TSUpdate`) in `lua/plugins/init.lua`.

local ts = require "nvim-treesitter"

-- Parsers to keep installed. Use `:TSInstall <lang>` for one-offs.
ts.install {
    "bash",
    "c",
    "diff",
    "html",
    "lua",
    "luadoc",
    "markdown",
    "markdown_inline",
    "query",
    "vim",
    "vimdoc",
    "python",
    "java",
}

-- Filetypes for which treesitter indentation (experimental) is *not* used.
local no_indent = { ruby = true }

vim.api.nvim_create_autocmd("FileType", {
    group = vim.api.nvim_create_augroup("treesitter-enable", { clear = true }),
    callback = function(ev)
        local ft = vim.bo[ev.buf].filetype
        local lang = vim.treesitter.language.get_lang(ft)
        if not lang then
            return
        end

        -- Only proceed if a parser for this language is actually available.
        local ok, added = pcall(vim.treesitter.language.add, lang)
        if not (ok and added) then
            return
        end

        -- Highlighting
        vim.treesitter.start(ev.buf)

        -- Indentation (experimental on the main branch)
        if not no_indent[ft] then
            vim.bo[ev.buf].indentexpr =
                "v:lua.require'nvim-treesitter'.indentexpr()"
        end
    end,
})

-- vim: ts=2 sts=2 sw=2 et
