-- Collection of various small independent plugins/modules

-- Better Around/Inside textobjects
--
-- Examples:
--  - va)  - [V]isually select [A]round [)]paren
--  - yiiq - [Y]ank [I]nside [I]+1 [Q]uote
--  - ci'  - [C]hange [I]nside [']quote
require("mini.ai").setup {
    -- NOTE: Avoid conflicts with the built-in incremental selection mappings on
    -- Neovim >= 0.12 (see `:help treesitter-incremental-selection`). The default
    -- next/last textobject prefixes (`an`/`in`) collide, so remap them.
    mappings = {
        around_next = "aa",
        inside_next = "ii",
    },
    n_lines = 500,
}

-- Add/delete/replace surroundings (brackets, quotes, etc.)
--
-- - saiw) - [S]urround [A]dd [I]nner [W]ord [)]Paren
-- - sd'   - [S]urround [D]elete [']quotes
-- - sr)'  - [S]urround [R]eplace [)] [']
require("mini.surround").setup()

require("mini.pairs").setup()
