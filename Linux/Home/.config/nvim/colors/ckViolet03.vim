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
hi PreProc         guifg=#ac99c8 guibg=#000000 gui=NONE cterm=NONE
hi Special         guifg=#8f3f38 guibg=#000000 gui=NONE cterm=NONE
hi Constant        guifg=#8171c8 guibg=#000000 gui=NONE cterm=NONE
hi Comment         guifg=#9d80c8 guibg=#210d3f gui=NONE cterm=NONE
hi Identifier      guifg=#a587c5 guibg=#000000 gui=NONE cterm=NONE
hi Statement       guifg=#9081c8 guibg=#000000 gui=NONE cterm=NONE
hi Type            guifg=#612fc6 guibg=#000000 gui=NONE cterm=NONE
hi Function        guifg=#734ac4 guibg=#000000 gui=NONE cterm=NONE
hi Title           guifg=#c76668 guibg=#000000 gui=NONE cterm=NONE
hi Underlined      guifg=#bfbf40 guibg=#000000 gui=NONE cterm=NONE
hi Search          guifg=#23c868 guibg=#0f3d22 gui=NONE cterm=NONE
hi CurSearch       guifg=#bfbfbf guibg=#000000 gui=NONE cterm=NONE
hi FoldColumn      guifg=#98493e guibg=#000000 gui=NONE cterm=NONE
hi SignColumn      guifg=#815dc8 guibg=#000000 gui=NONE cterm=NONE
hi DiagnosticError guifg=#bf4040 guibg=#2e1f1f gui=NONE cterm=NONE
hi DiagnosticHint  guifg=#bf8040 guibg=#2e261f gui=NONE cterm=NONE
hi DiagnosticInfo  guifg=#4055bf guibg=#1f212e gui=NONE cterm=NONE
hi DiagnosticOk    guifg=#40bf55 guibg=#1f2e21 gui=NONE cterm=NONE
hi DiagnosticWarn  guifg=#bf8040 guibg=#2e261f gui=NONE cterm=NONE
hi EndOfBuffer     guifg=#000000 guibg=#000000 gui=NONE cterm=NONE
hi NonText         guifg=#9382c8 guibg=#000000 gui=NONE cterm=NONE
hi Normal          guifg=#7a4baa guibg=#000000 gui=NONE cterm=NONE
hi LineNr          guifg=#583e74 guibg=#000000 gui=NONE cterm=NONE
hi CursorLineNr    guifg=#9464c8 guibg=#000000 gui=NONE cterm=NONE
hi StatusLine      guifg=#714b9b guibg=#000000 gui=NONE cterm=NONE
hi StatusLineNC    guifg=#7d40bf guibg=#190d26 gui=NONE cterm=NONE
hi Pmenu           guifg=#996c66 guibg=#000000 gui=NONE cterm=NONE
hi PmenuSel        guifg=#9b85c8 guibg=#241f2e gui=NONE cterm=NONE
hi Visual          guifg=#7861c8 guibg=#150845 gui=NONE cterm=NONE
hi WinBar          guifg=#c23c2e guibg=#000000 gui=NONE cterm=NONE
hi DiffAdd         guifg=#40bf80 guibg=#1f2e26 gui=NONE cterm=NONE
hi DiffDelete      guifg=#bf4040 guibg=#2e1f1f gui=NONE cterm=NONE
hi DiffChange      guifg=#6485c8 guibg=#1f242e gui=NONE cterm=NONE
hi ModeMsg         guifg=#7d40bf guibg=#261f2e gui=NONE cterm=NONE
hi MoreMsg         guifg=#7d40bf guibg=#261f2e gui=NONE cterm=NONE
hi Question        guifg=#7d40bf guibg=#261f2e gui=NONE cterm=NONE
hi MatchParen      guifg=#cccc00 guibg=#000000 gui=NONE cterm=NONE
hi WinSeparator    guifg=#000000 guibg=#000000 gui=NONE cterm=NONE
hi ErrorMsg        guifg=#cc0000 guibg=#500000 gui=NONE cterm=NONE
hi WarningMsg      guifg=#cc9900 guibg=#502000 gui=NONE cterm=NONE
hi Todo            guifg=#000000 guibg=#c0c000 gui=NONE cterm=NONE
