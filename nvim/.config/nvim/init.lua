-- Speed up Lua module loading (byte-compilation cache). ~30% faster startup.
-- Recommended by the vim.pack guide; safe to keep at the very top.
vim.loader.enable()

-- Set <space> as the leader key
--  NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Set to true if you have a Nerd Font installed and selected in the terminal
vim.g.have_nerd_font = true

-- [[ Setting options ]]
require "options"

-- [[ Basic Keymaps ]]
require "keymaps"

-- [[ Install and configure plugins ]] (via built-in vim.pack)
require "plugins"

-- The line beneath this is called `modeline`. See `:help modeline`
-- vim: ts=2 sts=2 sw=2 et
