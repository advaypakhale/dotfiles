-- basic_light — high-contrast light colorscheme: black on white, dark saturated
-- primaries, no pastels. Built to stay legible in direct sunlight.

vim.cmd("highlight clear")
if vim.fn.exists("syntax_on") then
    vim.cmd("syntax reset")
end
vim.o.background = "light"
vim.g.colors_name = "basic_light"

local white = "#ffffff"
local black = "#000000"
local grey = "#565656" -- comments / dim UI
local lgrey = "#8a8a8a" -- line numbers / borders
local xlgrey = "#c6c6c6" -- subtle fills
local band = "#e6e6e6" -- status/menu band

-- The basic palette: dark, saturated primaries.
local blue = "#0000c0" -- keywords
local green = "#006400" -- strings
local red = "#b00000" -- errors, preproc
local purple = "#9000a0" -- numbers, constants
local teal = "#007070" -- types

local function hl(group, opts)
    vim.api.nvim_set_hl(0, group, opts)
end

-- Editor UI
hl("Normal", { fg = black, bg = white })
hl("NormalFloat", { fg = black, bg = band })
hl("FloatBorder", { fg = lgrey, bg = band })
hl("Cursor", { fg = white, bg = black })
hl("CursorLine", { bg = "#f2f2f2" })
hl("CursorLineNr", { fg = black, bold = true })
hl("LineNr", { fg = lgrey })
hl("SignColumn", { bg = white })
hl("ColorColumn", { bg = "#f0f0f0" })
hl("VertSplit", { fg = xlgrey })
hl("WinSeparator", { fg = xlgrey })
hl("Folded", { fg = grey, bg = "#f0f0f0", italic = true })
hl("FoldColumn", { fg = lgrey })
hl("MatchParen", { bold = true, underline = true })
hl("NonText", { fg = "#c0c0c0" })
hl("Whitespace", { fg = "#d0d0d0" })
hl("EndOfBuffer", { fg = white })
hl("Directory", { fg = blue, bold = true })
hl("Title", { fg = blue, bold = true })

-- Selection / search
hl("Visual", { bg = "#cfe0ff" })
hl("Search", { fg = black, bg = "#ffe066" })
hl("IncSearch", { fg = white, bg = red })
hl("CurSearch", { fg = white, bg = red })

-- Statusline / tabline / menus
hl("StatusLine", { fg = black, bg = band })
hl("StatusLineNC", { fg = grey, bg = "#f0f0f0" })
hl("TabLine", { fg = grey, bg = "#f0f0f0" })
hl("TabLineSel", { fg = white, bg = blue, bold = true })
hl("TabLineFill", { bg = "#f0f0f0" })
hl("Pmenu", { fg = black, bg = band })
hl("PmenuSel", { fg = white, bg = blue, bold = true })
hl("PmenuSbar", { bg = xlgrey })
hl("PmenuThumb", { bg = grey })
hl("WildMenu", { fg = white, bg = blue })

-- Messages
hl("ErrorMsg", { fg = red, bold = true })
hl("WarningMsg", { fg = red })
hl("ModeMsg", { fg = black, bold = true })
hl("MoreMsg", { fg = green })
hl("Question", { fg = green })

-- Syntax: basic hues, one per role
hl("Comment", { fg = grey, italic = true })
hl("Statement", { fg = blue, bold = true })
hl("Keyword", { fg = blue, bold = true })
hl("Conditional", { fg = blue, bold = true })
hl("Repeat", { fg = blue, bold = true })
hl("Label", { fg = blue, bold = true })
hl("Exception", { fg = blue, bold = true })
hl("Operator", { fg = black })
hl("Type", { fg = teal, bold = true })
hl("StorageClass", { fg = teal, bold = true })
hl("Structure", { fg = teal, bold = true })
hl("Typedef", { fg = teal, bold = true })
hl("PreProc", { fg = red })
hl("Include", { fg = red, bold = true })
hl("Define", { fg = red })
hl("Macro", { fg = red })
hl("Function", { fg = black, bold = true })
hl("Identifier", { fg = black })
hl("Constant", { fg = purple })
hl("String", { fg = green })
hl("Character", { fg = green })
hl("Number", { fg = purple })
hl("Boolean", { fg = purple, bold = true })
hl("Float", { fg = purple })
hl("Special", { fg = red })
hl("SpecialChar", { fg = red })
hl("Delimiter", { fg = black })
hl("Tag", { fg = blue })
hl("Underlined", { fg = blue, underline = true })
hl("Todo", { fg = white, bg = blue, bold = true })
hl("Error", { fg = white, bg = red, bold = true })

-- Diagnostics
hl("DiagnosticError", { fg = red })
hl("DiagnosticWarn", { fg = "#9a6000" })
hl("DiagnosticInfo", { fg = blue })
hl("DiagnosticHint", { fg = teal })
hl("DiagnosticUnderlineError", { undercurl = true, sp = red })
hl("DiagnosticUnderlineWarn", { undercurl = true, sp = "#9a6000" })
hl("DiagnosticUnderlineInfo", { undercurl = true, sp = blue })
hl("DiagnosticUnderlineHint", { undercurl = true, sp = teal })

-- Diff / git
hl("DiffAdd", { bg = "#d6f0d6" })
hl("DiffChange", { bg = "#e6e6f5" })
hl("DiffDelete", { fg = red, bg = "#f4dede" })
hl("DiffText", { bg = "#c6d6f0", bold = true })
hl("Added", { fg = green, bold = true })
hl("Changed", { fg = blue })
hl("Removed", { fg = red })
hl("GitSignsAdd", { fg = green })
hl("GitSignsChange", { fg = blue })
hl("GitSignsDelete", { fg = red })

-- Treesitter: pin the groups that otherwise carry their own hue
hl("@variable", { fg = black })
hl("@variable.builtin", { fg = red, italic = true })
hl("@parameter", { fg = black })
hl("@field", { fg = black })
hl("@property", { fg = black })
hl("@constant", { fg = purple })
hl("@constant.builtin", { fg = purple, bold = true })
hl("@constructor", { fg = teal, bold = true })
hl("@function", { fg = black, bold = true })
hl("@function.builtin", { fg = black, bold = true })
hl("@function.call", { fg = black })
hl("@keyword", { fg = blue, bold = true })
hl("@string", { fg = green })
hl("@type", { fg = teal, bold = true })
hl("@punctuation", { fg = black })
hl("@punctuation.bracket", { fg = black })
hl("@punctuation.delimiter", { fg = black })
hl("@tag", { fg = blue, bold = true })
hl("@tag.attribute", { fg = teal, italic = true })
hl("@markup.heading", { fg = blue, bold = true })
hl("@markup.raw", { fg = green })
hl("@markup.link", { fg = blue, underline = true })
hl("@markup.strong", { fg = black, bold = true })
hl("@markup.italic", { fg = black, italic = true })
