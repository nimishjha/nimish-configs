hi clear
hi! link @attribute PreProc
hi! link @attribute.builtin Special
hi! link @boolean Constant
hi! link @character Constant
hi! link @character.special Special
hi! link @comment Comment
hi! link @comment.todo Todo
hi! link @constant Constant
hi! link @constant.builtin Special
hi! link @constant.macro PreProc
hi! link @constructor Special
hi! link @function Identifier
hi! link @function.builtin Special
hi! link @function.macro PreProc
hi! link @function.method Identifier
hi! link @keyword Statement
hi! link @keyword.function Function
hi! link @keyword.conditional Statement
hi! link @keyword.debug Special
hi! link @keyword.directive PreProc
hi! link @keyword.exception Statement
hi! link @keyword.import PreProc
hi! link @keyword.repeat Statement
hi! link @keyword.type Type
hi! link @label Statement
hi! link @lsp.type.class Type
hi! link @lsp.type.comment Comment
hi! link @lsp.type.decorator Identifier
hi! link @lsp.type.enum Type
hi! link @lsp.type.enumMember Constant
hi! link @lsp.type.function Function
hi! link @lsp.type.interface Type
hi! link @lsp.type.macro PreProc
hi! link @lsp.type.method Identifier
hi! link @lsp.type.namespace Type
hi! link @lsp.type.parameter Identifier
hi! link @lsp.type.property Identifier
hi! link @lsp.type.struct Type
hi! link @lsp.type.type Type
hi! link @lsp.type.typeParameter TypeDef
hi! link @lsp.type.variable Identifier
hi! link @markup.heading Title
hi! link @markup.link Identifier
hi! link @markup.link.url Underlined
hi! link @markup.raw Comment
hi! link @markup.underline Underlined
hi! link @module Identifier
hi! link @number Constant
hi! link @number.float Constant
hi! link @operator Statement
hi! link @property Identifier
hi! link @punctuation Special
hi! link @string Constant
hi! link @string.escape Special
hi! link @string.special Special
hi! link @tag Special
hi! link @tag.builtin Special
hi! link @type Type
hi! link @type.definition Type
hi! link @variable Identifier
hi! link @variable.member Identifier
hi! link @variable.parameter Identifier
hi! link @variable.parameter.builtin Special
hi! link Boolean Constant
hi! link Character Constant
hi! link Conditional Statement
hi! link CursorLineFold FoldColumn
hi! link CursorLineSign SignColumn
hi! link Debug Special
hi! link Define PreProc
hi! link Delimiter Special
hi! link DiagnosticFloatingError DiagnosticError
hi! link DiagnosticFloatingHint DiagnosticHint
hi! link DiagnosticFloatingInfo DiagnosticInfo
hi! link DiagnosticFloatingOk DiagnosticOk
hi! link DiagnosticFloatingWarn DiagnosticWarn
hi! link DiagnosticSignError DiagnosticError
hi! link DiagnosticSignHint DiagnosticHint
hi! link DiagnosticSignInfo DiagnosticInfo
hi! link DiagnosticSignOk DiagnosticOk
hi! link DiagnosticSignWarn DiagnosticWarn
hi! link DiagnosticUnnecessary Comment
hi! link DiagnosticVirtualTextError DiagnosticError
hi! link DiagnosticVirtualTextHint DiagnosticHint
hi! link DiagnosticVirtualTextInfo DiagnosticInfo
hi! link DiagnosticVirtualTextOk DiagnosticOk
hi! link DiagnosticVirtualTextWarn DiagnosticWarn
hi! link Exception Statement
hi! link Float Constant
hi! link FloatBorder Normal
hi! link FloatFooter Title
hi! link FloatTitle Title
hi! link Include PreProc
hi! link Keyword Statement
hi! link Label Statement
hi! link LineNrAbove LineNr
hi! link LineNrBelow LineNr
hi! link LspInlayHint NonText
hi! link Macro PreProc
hi! link MsgSeparator StatusLine
hi! link NormalFloat Pmenu
hi! link Number Constant
hi! link Operator Statement
hi! link PmenuExtra Pmenu
hi! link PmenuExtraSel PmenuSel
hi! link PmenuKind Pmenu
hi! link PmenuKindSel PmenuSel
hi! link PmenuMatch Pmenu
hi! link PmenuMatchSel PmenuSel
hi! link PreCondit PreProc
hi! link QuickFixLine Search
hi! link Repeat Statement
hi! link SnippetTabstop Visual
hi! link SpecialChar Special
hi! link SpecialComment Special
hi! link StorageClass Type
hi! link String Constant
hi! link Structure Type
hi! link Substitute Search
hi! link Tag Special
hi! link Typedef Type
hi! link VertSplit Normal
hi! link Whitespace NonText
hi! link WinBarNC WinBar
hi! link WinSeparator Normal
hi! link Added DiffAdd
hi! link Changed DiffChange
hi! link Removed DiffDelete
hi PreProc         guifg=#3caec8 guibg=#041025 gui=NONE cterm=NONE
hi Special         guifg=#0049c8 guibg=#041025 gui=NONE cterm=NONE
hi Constant        guifg=#c87e2e guibg=#041025 gui=NONE cterm=NONE
hi Comment         guifg=#80bbc8 guibg=#0d373f gui=NONE cterm=NONE
hi Identifier      guifg=#5982c8 guibg=#041025 gui=NONE cterm=NONE
hi Statement       guifg=#1858c8 guibg=#041025 gui=NONE cterm=NONE
hi Type            guifg=#09c0c3 guibg=#041025 gui=NONE cterm=NONE
hi Function        guifg=#6c59c8 guibg=#041025 gui=NONE cterm=NONE
hi Title           guifg=#518bc8 guibg=#041025 gui=NONE cterm=NONE
hi Underlined      guifg=#bfbf40 guibg=#000000 gui=NONE cterm=NONE
hi Search          guifg=#23c868 guibg=#0f3d22 gui=NONE cterm=NONE
hi CurSearch       guifg=#bfbfbf guibg=#000000 gui=NONE cterm=NONE
hi FoldColumn      guifg=#c77313 guibg=#041025 gui=NONE cterm=NONE
hi SignColumn      guifg=#c89c3d guibg=#07090e gui=NONE cterm=NONE
hi DiagnosticError guifg=#bf4040 guibg=#2e1f1f gui=NONE cterm=NONE
hi DiagnosticHint  guifg=#bf8040 guibg=#2e261f gui=NONE cterm=NONE
hi DiagnosticInfo  guifg=#4055bf guibg=#1f212e gui=NONE cterm=NONE
hi DiagnosticOk    guifg=#40bf55 guibg=#1f2e21 gui=NONE cterm=NONE
hi DiagnosticWarn  guifg=#bf8040 guibg=#2e261f gui=NONE cterm=NONE
hi EndOfBuffer     guifg=#000000 guibg=#000000 gui=NONE cterm=NONE
hi NonText         guifg=#3aa0c8 guibg=#041025 gui=NONE cterm=NONE
hi Normal          guifg=#11b2c8 guibg=#041025 gui=NONE cterm=NONE
hi LineNr          guifg=#3e5274 guibg=#07090e gui=NONE cterm=NONE
hi CursorLineNr    guifg=#6489c8 guibg=#07090e gui=NONE cterm=NONE
hi StatusLine      guifg=#4b689b guibg=#07090e gui=NONE cterm=NONE
hi StatusLineNC    guifg=#3e5274 guibg=#000000 gui=NONE cterm=NONE
hi Pmenu           guifg=#998c66 guibg=#000000 gui=NONE cterm=NONE
hi PmenuSel        guifg=#8c85c8 guibg=#201f2e gui=NONE cterm=NONE
hi Visual          guifg=#c8a661 guibg=#453008 gui=NONE cterm=NONE
hi WinBar          guifg=#c88034 guibg=#041025 gui=NONE cterm=NONE
hi DiffAdd         guifg=#15c86f guibg=#1b3226 gui=NONE cterm=NONE
hi DiffDelete      guifg=#c81515 guibg=#321b1b gui=NONE cterm=NONE
hi DiffChange      guifg=#3c6bc8 guibg=#1b2232 gui=NONE cterm=NONE
hi ModeMsg         guifg=#406fbf guibg=#1f242e gui=NONE cterm=NONE
hi MoreMsg         guifg=#406fbf guibg=#1f242e gui=NONE cterm=NONE
hi Question        guifg=#406fbf guibg=#1f242e gui=NONE cterm=NONE
hi MatchParen      guifg=#cccc00 guibg=#000000 gui=NONE cterm=NONE
hi WinSeparator    guifg=#000000 guibg=#000000 gui=NONE cterm=NONE
hi ErrorMsg        guifg=#cc0000 guibg=#500000 gui=NONE cterm=NONE
hi WarningMsg      guifg=#cc9900 guibg=#502000 gui=NONE cterm=NONE
hi Todo            guifg=#000000 guibg=#c0c000 gui=NONE cterm=NONE
