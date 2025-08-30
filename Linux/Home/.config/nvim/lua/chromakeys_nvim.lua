local M = {}

local settings = {
	colorSchemes = {},
	currentColorSchemeIndex = -1,
	colorSchemeGroups = {},
	fgVars = {},
	bgVars = {},
	allVars = {},
	fgColors = {},
	base = {
		h = 220,
		s = 50,
		l = 50
	},
	allExceptFgNormalAsOne = {
		h = 220,
		s = 40,
		l = 50
	},
	scopes = {},
	baseScope = "fgIdentifier",
	colorFunctions = {},
	uniformBrightness = 70,
	minFgBrightness = 35,
	maxFgBrightness = 75,
	maxBgBrightness = 15,
	backgroundLightness = 8,
	backgroundSaturation = 50,
	commentBgLightness = 15,
	shouldForceUniformBrightness = false,
	shouldEnsureSeparation = false,
	shouldLimitChannelValues = true,
	shouldLockFgNormalToBaseColor = false,
	shouldRecalculateDerivedColors = true,
	shouldAdjustPerceptualBrightness = true,
	maxChannelValue = 200,
	rulesMap = {},
	currentScope = "fgNormal",
	colorSchemesDir = "",
	currentColorScheme = "zzChromaKeys1",
	colorSchemePrefix = "ck",
	colorSchemeA = nil,
	colorSchemeB = nil,
	logString = "",
	colorSchemeText = "",
	hueStep = 1,
	saturationStep = 1,
	lightnessStep = 0.25,
	hueCycleStep = 10,
	palettes = {
		VioletCyanRedOrange = { 250, 190, 0, 40 },
		BlueOrange          = { 220, 40 },
		OrangeBlue          = { 40, 45, 50, 55, 220, 240 },
		MoreBlueLessOrange  = { 210, 220, 230, 240, 30, 40 },
		BlueYellow          = { 220, 240, 60 },
		BlueRed             = { 220, 230, 240, 350, 0 },
		BlueCyan            = { 220, 240, 190 },
		BlueGreen           = { 210, 220, 230, 240, 130, 140 },
		CyanYellow          = { 190, 60 },
		CyanOrange          = { 180, 190, 40 },
		VioletBlue          = { 250, 260, 220 },
		VioletGreen         = { 250, 260, 160 },
		VioletCyan          = { 250, 260, 190 },
		VioletYellow        = { 250, 260, 60 },
		VioletOrange        = { 250, 260, 30 },
		VioletRed           = { 250, 260, 0 },
		VioletPink          = { 250, 260, 330 },
		GreenCyan           = { 110, 130, 150, 170, 180, 190 },
		GreenYellow         = { 120, 130, 140, 160, 45, 55 },
		Violet              = { 250, 255, 260, 265, 270, 280 },
		Blue                = { 220, 230, 240 },
		Cyan                = { 170, 180, 190 },
		Cyan2               = { 160, 170 },
		Green               = { 80, 90, 110, 120, 130, 140, 150, 160 },
		Green2              = { 140, 150 },
		Red                 = { 350, 0, 5 },
		Pink                = { 315, 320, 325, 330, 335 },
		RedPink             = { 0, 330 },
		Orange              = { 20, 30 },
		Yellow              = { 55, 65 },
		CyanBlueOrange      = { 180, 190, 220, 230, 240, 40 },
		BlueRedOrange       = { 230, 240, 250, 350, 0, 40 },
		BlueCyanOrange      = { 240, 210, 190, 180, 30, 40 },
	},
	isDebugMode = false,
	showStatusOnLoad = false,
	generationCount = 0,
}

local ACTIONS = {
	HUE_INCREASE              = 1,
	HUE_DECREASE              = 2,
	SATURATION_INCREASE       = 3,
	SATURATION_DECREASE       = 4,
	LIGHTNESS_INCREASE        = 5,
	LIGHTNESS_DECREASE        = 6,
	HUE_INCREASE_LARGE        = 7,
	HUE_DECREASE_LARGE        = 8,
	SATURATION_INCREASE_LARGE = 9,
	SATURATION_DECREASE_LARGE = 10,
	LIGHTNESS_INCREASE_LARGE  = 11,
	LIGHTNESS_DECREASE_LARGE  = 12,
	RANDOMISE                 = 15,
	RANDOMISE_HUE             = 16,
	RANDOMISE_SATURATION      = 17,
	RANDOMISE_LIGHTNESS       = 18,
}

local SPECIAL_SCOPES = {
	ALL_EXCEPT_FGNORMAL_AS_ONE = "allExceptFgNormalAsOne",
	ALL_EXCEPT_FGNORMAL = "allExceptfgNormal",
	ALL = "all",
	BASE = "base",
}

local SPECIAL_SCOPES_ORDER = {
	"ALL_EXCEPT_FGNORMAL_AS_ONE",
	"ALL_EXCEPT_FGNORMAL",
	"ALL",
	"BASE"
}





local Cyclable = {}
Cyclable.__index = Cyclable

function Cyclable.new(variableNames)
	local self = setmetatable({}, Cyclable)
	self.variables = {}
	self.currentVariable = nil
	self.currentIndex = 0

	if type(variableNames) == "table" then
		for _, name in ipairs(variableNames) do
			if type(name) == "string" and name ~= "" then
				table.insert(self.variables, name)
			end
		end
		if #self.variables > 0 then
			self.currentIndex = 1
			self.currentVariable = self.variables[1]
		end
	end

	return self
end

function Cyclable:current()
	return self.currentVariable
end

function Cyclable:next()
	if #self.variables == 0 then
		self.currentIndex = 0
		self.currentVariable = nil
		return nil
	end

	self.currentIndex = self.currentIndex + 1
	if self.currentIndex > #self.variables then
		self.currentIndex = 1
	end
	self.currentVariable = self.variables[self.currentIndex]
	return self.currentVariable
end

function Cyclable:previous()
	if #self.variables == 0 then
		self.currentIndex = 0
		self.currentVariable = nil
		return nil
	end

	self.currentIndex = self.currentIndex - 1
	if self.currentIndex < 1 then
		self.currentIndex = #self.variables
	end
	self.currentVariable = self.variables[self.currentIndex]
	return self.currentVariable
end

function Cyclable:getVariables()
	return self.variables
end

function Cyclable:add(value)
	table.insert(self.variables, value)
	if self.currentIndex == nil or self.currentIndex == 0 then
		self.currentIndex = #self.variables
		self.currentVariable = value
	end
end

function Cyclable:addAndSelect(value)
	table.insert(self.variables, value)
	self.currentIndex = #self.variables
	self.currentVariable = value
end

function Cyclable:debug()
	for _, value in pairs(self.variables) do
		forceLog(value[1])
	end
	forceLog("currentIndex: " .. tostring(self.currentIndex) .. ", current: " .. tostring(self:current()))
end

function Cyclable:select(valueToSelect)
	for index, value in pairs(self.variables) do
		if value == valueToSelect then
			self.currentVariable = value
			self.currentIndex = index
		end
	end
end




local colorSchemeTemplate = [[
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
hi PreProc         guifg={{fgPreProc}} guibg={{bgPreProc}} gui=NONE cterm=NONE
hi Special         guifg={{fgSpecial}} guibg={{bgSpecial}} gui=NONE cterm=NONE
hi Constant        guifg={{fgConstant}} guibg={{bgConstant}} gui=NONE cterm=NONE
hi Comment         guifg={{fgComment}} guibg={{bgComment}} gui=NONE cterm=NONE
hi Identifier      guifg={{fgIdentifier}} guibg={{bgIdentifier}} gui=NONE cterm=NONE
hi Statement       guifg={{fgStatement}} guibg={{bgStatement}} gui=NONE cterm=NONE
hi Type            guifg={{fgType}} guibg={{bgType}} gui=NONE cterm=NONE
hi Function        guifg={{fgFunction}} guibg={{bgFunction}} gui=NONE cterm=NONE
hi Title           guifg={{fgTitle}} guibg={{bgTitle}} gui=NONE cterm=NONE
hi Underlined      guifg={{fgUnderlined}} guibg={{bgUnderlined}} gui=NONE cterm=NONE
hi Search          guifg={{fgSearch}} guibg={{bgSearch}} gui=NONE cterm=NONE
hi CurSearch       guifg={{fgCurSearch}} guibg={{bgCurSearch}} gui=NONE cterm=NONE
hi FoldColumn      guifg={{fgFoldColumn}} guibg={{bgFoldColumn}} gui=NONE cterm=NONE
hi SignColumn      guifg={{fgSignColumn}} guibg={{bgSignColumn}} gui=NONE cterm=NONE
hi DiagnosticError guifg={{fgDiagnosticError}} guibg={{bgDiagnosticError}} gui=NONE cterm=NONE
hi DiagnosticHint  guifg={{fgDiagnosticHint}} guibg={{bgDiagnosticHint}} gui=NONE cterm=NONE
hi DiagnosticInfo  guifg={{fgDiagnosticInfo}} guibg={{bgDiagnosticInfo}} gui=NONE cterm=NONE
hi DiagnosticOk    guifg={{fgDiagnosticOk}} guibg={{bgDiagnosticOk}} gui=NONE cterm=NONE
hi DiagnosticWarn  guifg={{fgDiagnosticWarn}} guibg={{bgDiagnosticWarn}} gui=NONE cterm=NONE
hi EndOfBuffer     guifg={{fgEndOfBuffer}} guibg={{bgEndOfBuffer}} gui=NONE cterm=NONE
hi NonText         guifg={{fgNonText}} guibg={{bgNonText}} gui=NONE cterm=NONE
hi Normal          guifg={{fgNormal}} guibg={{bgNormal}} gui=NONE cterm=NONE
hi LineNr          guifg={{fgLineNr}} guibg={{bgLineNr}} gui=NONE cterm=NONE
hi CursorLineNr    guifg={{fgCursorLineNr}} guibg={{bgCursorLineNr}} gui=NONE cterm=NONE
hi StatusLine      guifg={{fgStatusLine}} guibg={{bgStatusLine}} gui=NONE cterm=NONE
hi StatusLineNC    guifg={{fgStatusLineNC}} guibg={{bgStatusLineNC}} gui=NONE cterm=NONE
hi Pmenu           guifg={{fgPmenu}} guibg={{bgPmenu}} gui=NONE cterm=NONE
hi PmenuSel        guifg={{fgPmenuSel}} guibg={{bgPmenuSel}} gui=NONE cterm=NONE
hi Visual          guifg={{fgVisual}} guibg={{bgVisual}} gui=NONE cterm=NONE
hi WinBar          guifg={{fgWinBar}} guibg={{bgWinBar}} gui=NONE cterm=NONE
hi DiffAdd         guifg={{fgDiffAdd}} guibg={{bgDiffAdd}} gui=NONE cterm=NONE
hi DiffDelete      guifg={{fgDiffDelete}} guibg={{bgDiffDelete}} gui=NONE cterm=NONE
hi DiffChange      guifg={{fgDiffChange}} guibg={{bgDiffChange}} gui=NONE cterm=NONE
hi ModeMsg         guifg={{fgModeMsg}} guibg={{bgModeMsg}} gui=NONE cterm=NONE
hi MoreMsg         guifg={{fgMoreMsg}} guibg={{bgMoreMsg}} gui=NONE cterm=NONE
hi Question        guifg={{fgMoreMsg}} guibg={{bgMoreMsg}} gui=NONE cterm=NONE
hi MatchParen      guifg=#cccc00 guibg=#000000 gui=NONE cterm=NONE
hi WinSeparator    guifg=#000000 guibg=#000000 gui=NONE cterm=NONE
hi ErrorMsg        guifg=#cc0000 guibg=#500000 gui=NONE cterm=NONE
hi WarningMsg      guifg=#cc9900 guibg=#502000 gui=NONE cterm=NONE
hi Todo            guifg=#000000 guibg=#c0c000 gui=NONE cterm=NONE
]]





function toggleDebugMode()
	settings.isDebugMode = not settings.isDebugMode
	showMessage(settings.isDebugMode and "Debug mode ON" or "Debug mode OFF")
end

function toggleConstraints()
	settings.shouldRecalculateDerivedColors = not settings.shouldRecalculateDerivedColors
	local message = settings.shouldRecalculateDerivedColors and "Derived colors ON" or "Derived colors OFF"
	showMessage(message)
end

function showMessage(s)
	print(s)
end

function showError(s)
	print("Error: " .. s)
end

function log(arg)
	if not settings.isDebugMode then return end
	if type(arg) ~= "string" then arg = tostring(arg) end
	print(arg .. "\n")
end

function forceLog(arg)
	if type(arg) ~= "string" then arg = tostring(arg) end
	print(arg .. "\n")
end

function logSeparator()
	if settings.isDebugMode then
		log(string.rep("–", 80))
	end
end

function currentScopeInfoToString()
	local currentScope = settings.scopes:current()
	local scopeInfo = padToWidth("scope: " .. currentScope, 32)
	if currentScope == SPECIAL_SCOPES.BASE then
		return scopeInfo .. debugHslColorShort(settings.base)
	elseif currentScope == SPECIAL_SCOPES.ALL or currentScope == SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL then
		return padToWidth(scopeInfo, 54)
	elseif currentScope == SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL_AS_ONE then
		return scopeInfo .. debugHslColorShort(makeHsl(settings.allExceptFgNormalAsOne.h, settings.allExceptFgNormalAsOne.s, settings.allExceptFgNormalAsOne.l))
	end
	local color = settings.rulesMap[currentScope]
	if color ~= nil then
		return scopeInfo .. debugHslColorShort(makeHsl(color.h, color.s, color.l))
	else
		return scopeInfo .. padToWidth(" (no color set)", 28)
	end
end

function getMaxChannelValue(rules)
	local highestChannelValue = 0
	for scope, hslColor in pairs(rules) do
		local hex = hslToHex(hslColor)
		local r, g, b = hexToRgb(hex)
		local max = math.max(r, g, b)
		if max > highestChannelValue then
			highestChannelValue = max
		end
	end
	return highestChannelValue
end

function debugHslColor(hslValue)
	assert(type(hslValue) == "table", "debugHslColor: hslValue is not a table")
	local h, s, l = splitHsl(hslValue)
	local hex = hslToHex({ h = h, s = s, l = l })
	local r, g, b = hexToRgb(hex)
	h = math.floor(h)
	s = math.floor(s)
	l = math.floor(l)
	return string.format("%4s%4s%4s%10s%8s%4s%4s%6s%8s", h, s, l, hex, r, g, b, calcBrightnessHex(hex), getBrightestChannel(hex))
end

function debugHslColorShort(hslValue)
	assert(type(hslValue) == "table", "debugHslColorShort: hslValue is not a table")
	local h, s, l = splitHsl(hslValue)
	h = math.floor(h)
	s = math.floor(s)
	local hex = hslToHex(hslValue)
	local lFormatted = string.format("%.2f", l)
	return string.format("%4s%4s%7s%10s", h, s, lFormatted, hex)
end

function logRules(isForced)
	if not settings.isDebugMode and isForced == nil then return end
	local logString = string.format("\n%s%29s%15s%11s%23s%s", "Scope", "HSL", "Hex", "RGB", "Brightness\n", string.rep("–", 82) .. "\n")
	for scope, color in pairs(settings.rulesMap) do
		logString = logString .. padToWidth(scope, 30) .. debugHslColor(color) .. "\n"
	end
	forceLog(logString)
end

function forceLogRules()
	logRules(true)
end

function makeString(...)
	local str = ""
	for _, value in ipairs({ ... }) do
		str = str .. value .. " "
	end
	return str
end

function addLog(str)
	settings.logString = settings.logString .. str .. " ◼ "
end

function showStatus()
	local statusInfo = padToWidth(settings.colorFunctions:current()[1], 24) .. " ◼ " .. currentScopeInfoToString()
	print(statusInfo .. " ◼ " .. settings.logString)
	settings.logString = ""
end

function addHue(hue, num)
	hue = hue + num
	if hue > 359 then
		hue = 0
	elseif hue < 1 then
		hue = 359
	end
	return hue
end

function calcBrightness(r, g, b)
	local brightness = math.floor((r + g + b) * 0.1307)
	return clamp(brightness, 0, 100)
end

function calcBrightnessHex(hexColor)
	local r, g, b = hexToRgb(hexColor)
	return calcBrightness(r, g, b)
end

function getBrightestChannel(hex)
	local r, g, b = hexToRgb(hex)
	local maxValue = math.max(r, g, b)
	if maxValue > settings.maxChannelValue then maxValue = "! " .. maxValue end
	return maxValue
end

function normTo255(norm)
	return clamp(math.floor(norm * 255), 0, 255)
end

function clamp(n, min, max)
	if n < min then return min end
	if n > max then return max end
	return n
end

function padToWidth(str, width)
	local len = string.len(str)
	if len > width then return str end
	return str .. string.rep(" ", width - len)
end

function shuffle(array)
	local n = #array
	for i = n, 2, -1 do
		local j = math.random(1, i)
		array[i], array[j] = array[j], array[i]
	end
	return array
end

function getTableLength(tableInstance)
	local count = 0
	for _ in pairs(tableInstance) do
		count = count + 1
	end
	return count
end

function exclude(list, excludeList)
	local excludeLookup = {}
	for _, str in ipairs(excludeList) do
		excludeLookup[str] = true
	end

	local filteredList = {}
	for _, str in ipairs(list) do
		if excludeLookup[str] == nil then
			table.insert(filteredList, str)
		end
	end

	return filteredList
end

function concat(list1, list2)
	local result = {}
	for _, value in ipairs(list1) do
		table.insert(result, value)
	end
	for _, value in ipairs(list2) do
		table.insert(result, value)
	end
	return result
end

function setTemplateVariables()
	local fgVars, bgVars = getTemplateVars()

	table.sort(fgVars)
	table.sort(bgVars)

	settings.fgVars = exclude(fgVars, {
		"fgDiagnosticError",
		"fgDiagnosticHint",
		"fgDiagnosticInfo",
		"fgDiagnosticOk",
		"fgDiagnosticWarn",
		"fgDiffAdd",
		"fgDiffChange",
		"fgDiffDelete",
		"fgEndOfBuffer",
		"fgModeMsg",
		"fgMoreMsg",
		"fgStatusLineNC",
	})

	settings.bgVars = exclude(bgVars, {
		"bgDiagnosticError",
		"bgDiagnosticHint",
		"bgDiagnosticInfo",
		"bgDiagnosticOk",
		"bgDiagnosticWarn",
		"bgDiffAdd",
		"bgDiffChange",
		"bgDiffDelete",
		"bgEndOfBuffer",
		"bgModeMsg",
		"bgMoreMsg",
		"bgStatusLineNC",
	})

	settings.fgVarsThatShouldBeBright = exclude(fgVars, { "fgLineNr", "fgStatusLine" })

	settings.allVars = concat(settings.fgVars, settings.bgVars)

	for scope, scopeString in pairs(SPECIAL_SCOPES) do
		table.insert(settings.allVars, scopeString)
	end
end





function loadAvailableColorSchemes()
	local colorSchemeFiles = vim.api.nvim_get_runtime_file("colors/*.{vim,lua}", true)
	local filteredColorSchemeNames = {}
	for _, fileName in ipairs(colorSchemeFiles) do
		if string.match(fileName, "%.config") ~= nil then
			local baseName = string.match(fileName, "[%w_]+%.[%w]+$")
			local baseNameWithoutExt = string.gsub(baseName, "%.lua", ""):gsub("%.vim", "")
			table.insert(filteredColorSchemeNames, baseNameWithoutExt)
		end
	end
	settings.colorSchemes = filteredColorSchemeNames
end

function getNextString(array, currentString)
	local currentIndex = nil
	for i, v in ipairs(array) do
		if v == currentString then
			currentIndex = i
			break
		end
	end

	if not currentIndex then
		return array[1]
	end

	local nextIndex = (currentIndex % #array) + 1
	return array[nextIndex]
end

function getPreviousString(array, currentString)
	local currentIndex = nil
	for i, v in ipairs(array) do
		if v == currentString then
			currentIndex = i
			break
		end
	end

	if not currentIndex then
		return array[1]
	end

	local nextIndex = currentIndex - 1
	if nextIndex < 1 then
		nextIndex = #array
	end
	return array[nextIndex]
end

function selectColorScheme(colorScheme)
	if colorScheme ~= nil then
		-- config.SetGlobalOption("colorscheme", colorScheme)
		-- createRulesFromScheme()
		-- showMessage(string.format("Color scheme set to %s max channel value is %s", padToWidth(colorScheme, 20), settings.originalRulesMaxChannelValue))
		vim.cmd.colorscheme(colorScheme)
		print("colorscheme: " .. colorScheme)
	else
		print("selectColorScheme: received nil for colorScheme")
	end
end

function nextColorScheme()
	loadAvailableColorSchemes()

	if settings.currentColorSchemeIndex	< 1 then
		settings.currentColorSchemeIndex = 1
	end

	settings.currentColorSchemeIndex = settings.currentColorSchemeIndex + 1
	if settings.currentColorSchemeIndex > #settings.colorSchemes then
		settings.currentColorSchemeIndex = 1
	end

	selectColorScheme(settings.colorSchemes[settings.currentColorSchemeIndex])
end

function previousColorScheme()
	loadAvailableColorSchemes()

	if settings.currentColorSchemeIndex	< 1 then
		settings.currentColorSchemeIndex = 1
	end

	settings.currentColorSchemeIndex = settings.currentColorSchemeIndex - 1
	if settings.currentColorSchemeIndex < 1 then
		settings.currentColorSchemeIndex = #settings.colorSchemes
	end

	selectColorScheme(settings.colorSchemes[settings.currentColorSchemeIndex])
end

function firstColorScheme()
	if settings.colorSchemes[1] ~= nil then
		selectColorScheme(settings.colorSchemes[1])
	else
		showMessage("No color schemes were detected")
	end
end

function randomColorScheme()
	if settings.colorSchemes[1] ~= nil then
		local colorScheme = settings.colorSchemes[math.random(1, #settings.colorSchemes)]
		selectColorScheme(colorScheme)
	else
		showMessage("No color schemes were detected")
	end
end

function nextGroup()
	if not (#settings.colorSchemes > 0 and #settings.colorSchemeGroups > 0) then
		showMessage("~/.config/micro/colorschemes is empty, create some color schemes first.")
		return
	end
	local currentScheme = config.GetGlobalOption("colorscheme")
	local currentGroup = string.gsub(currentScheme, "%d+", "")
	local nextGroup = getNextString(settings.colorSchemeGroups, currentGroup)

	local found = false
	for _, schemeName in ipairs(settings.colorSchemes) do
		if string.gsub(schemeName, "%d+", "") == nextGroup then
			found = true
			selectColorScheme(schemeName)
			break
		end
	end

	if not found then
		showMessage("nextGroup: could not find the next scheme")
	end
end

function setColorSchemeA()
	local currentColorScheme = config.GetGlobalOption("colorscheme")
	settings.colorSchemeA = currentColorScheme
	showMessage(currentColorScheme .. " saved to A")
end

function setColorSchemeB()
	local currentColorScheme = config.GetGlobalOption("colorscheme")
	settings.colorSchemeB = currentColorScheme
	showMessage(currentColorScheme .. " saved to B")
end

function selectColorSchemeA()
	if settings.colorSchemeA ~= nil then
		selectColorScheme(settings.colorSchemeA)
	else
		showMessage("Color scheme A has not been set")
	end
end

function selectColorSchemeB()
	if settings.colorSchemeB ~= nil then
		selectColorScheme(settings.colorSchemeB)
	else
		showMessage("Color scheme B has not been set")
	end
end





function extractVariables(template)
	local variables = {}
	local seen = {}

	for var in template:gmatch("{{(%w+)}}") do
		if not seen[var] then
			seen[var] = true
			table.insert(variables, var)
		end
	end

	return variables
end

function replaceVariables(template, vars)
	local result = template
	for name, hslValue in pairs(vars) do
		local pattern = "{{(" .. name .. ")}}"
		result = result:gsub(pattern, "#" .. hslToHex(hslValue))
	end
	return result
end

function makeHsl(hue, sat, lig)
	assert(type(hue) == "number" and type(sat) == "number" and type(lig) == "number", string.format("makeHsl: expected 3 numbers, got %s %s %s", type(hue), type(sat), type(lig)))
	return { h = hue, s = sat, l = lig }
end

function splitHsl(hslValue)
	return hslValue.h, hslValue.s, hslValue.l
end

function hslToString(hslValue)
	return hslValue.h .. " " .. hslValue.s .. " " .. hslValue.l
end

function colorsAreTooClose(a, b)
	local h1, s1, l1 = splitHsl(a)
	local h2, s2, l2 = splitHsl(b)
	return math.abs(h1 - h2) < 10 and math.abs(s1 - s2) < 10 and math.abs(l1 - l2) < 10
end

function isNotTooGarish(r, g, b)
	if r > 127 and g < 127 then
		return false
	end
	return true
end

function hslToRgb(hslValue)
	assert(isValidHsl(hslValue), "hslToRgb: invalid hsl value")

	local h = hslValue.h
	local s = hslValue.s
	local l = hslValue.l

	h = h % 360 / 360
	s = math.max(0, math.min(1, s / 100))
	l = math.max(0, math.min(1, l / 100))

	if s == 0 then
		return l * 100, l * 100, l * 100
	end

	local temp2 = l < 0.5 and l * (1 + s) or l + s - l * s
	local temp1 = 2 * l - temp2

	local function hueToRgb(t)
		if t < 0 then t = t + 1 end
		if t > 1 then t = t - 1 end
		if t < 1/6 then return temp1 + (temp2 - temp1) * 6 * t end
		if t < 1/2 then return temp2 end
		if t < 2/3 then return temp1 + (temp2 - temp1) * (2/3 - t) * 6 end
		return temp1
	end

	local r = hueToRgb(h + 1/3)
	local g = hueToRgb(h)
	local b = hueToRgb(h - 1/3)

	r = math.floor(r * 255 + 0.5)
	g = math.floor(g * 255 + 0.5)
	b = math.floor(b * 255 + 0.5)

	return r, g, b
end

function rgbToHex(r, g, b)
	return string.format("%02x%02x%02x", r, g, b)
end

function hexToRgb(hex)
	assert(hex ~= nil and string.len(hex) == 6, "hexToRgb: invalid hex value")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)
	return r, g, b
end

function dimForBackground(hslValue)
	return makeHsl(hslValue.h, hslValue.s, math.min(hslValue.l, settings.backgroundLightness))
end

function ensureSeparationFromDefault(...)
	local fgColor = settings.rulesMap.fgNormal
	for _, scope in ipairs({ ... }) do
		local color = settings.rulesMap[scope]
		if colorsAreTooClose(color, fgColor) then
			local h, s, l = splitHsl(color)
			log(string.format("%s (%s) is too close to %s (%s)", scope, makeString(h, s, l), "fgNormal", hslToString(fgColor) ))
			local adjustment = 15
			if l + adjustment > settings.maxFgBrightness then adjustment = -15 end
			setScopeColor(scope, makeHsl(h, s, l + adjustment))
		end
	end
end

function multiplyHexColor(hex, multiplier)
	local r, g, b = hexToRgb(hex)
	r = math.floor(clamp(r * multiplier, 0, settings.maxChannelValue))
	g = math.floor(clamp(g * multiplier, 0, settings.maxChannelValue))
	b = math.floor(clamp(b * multiplier, 0, settings.maxChannelValue))
	return rgbToHex(r, g, b)
end

function hslToHex(hslValue)
	assert(isValidHsl(hslValue), "hslToHex: invalid hsl value")

	local h = hslValue.h
	local s = hslValue.s
	local l = hslValue.l

	h = h % 360 / 360
	s = tonumber(s, 10)
	l = tonumber(l, 10)
	s = math.max(0, math.min(1, s / 100))
	l = math.max(0, math.min(1, l / 100))

	local temp2 = l < 0.5 and l * (1 + s) or l + s - l * s
	local temp1 = 2 * l - temp2

	local function hueToRgb(t)
		if t < 0 then t = t + 1 end
		if t > 1 then t = t - 1 end
		if t < 1/6 then return temp1 + (temp2 - temp1) * 6 * t end
		if t < 1/2 then return temp2 end
		if t < 2/3 then return temp1 + (temp2 - temp1) * (2/3 - t) * 6 end
		return temp1
	end

	local r = hueToRgb(h + 1/3)
	local g = hueToRgb(h)
	local b = hueToRgb(h - 1/3)

	r = math.floor(r * 255 + 0.5)
	g = math.floor(g * 255 + 0.5)
	b = math.floor(b * 255 + 0.5)

	return string.format("%02x%02x%02x", r, g, b)
end

function hexToHsl(hex)
	assert(type(hex) == "string" and string.len(hex) == 6, string.format("hexToHsl: invalid hex value %s", hex))

	local r = tonumber(hex:sub(1, 2), 16) / 255
	local g = tonumber(hex:sub(3, 4), 16) / 255
	local b = tonumber(hex:sub(5, 6), 16) / 255

	local max = math.max(r, g, b)
	local min = math.min(r, g, b)

	local h, s, l = 0, 0, (max + min) / 2

	if max ~= min then
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)

		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		elseif max == b then
			h = (r - g) / d + 4
		end
		h = h / 6
	end

	h = math.floor(h * 360 + 0.5)
	s = math.floor(s * 100 + 0.5)
	l = l * 100

	return makeHsl(h, s, l)
end

function hexToHslWithFallback(hex)
	if isValidHex(hex) then
		return hexToHsl(hex)
	end
	forceLog(string.format("%s is not a valid hex color", hex))
	return makeHsl(66, 66, 66)
end

function isBackgroundScope(scope)
	assert(type(scope) == "string" and string.len(scope) > 0, "scope is not a string or has zero length")
	if scope:match("^bg") ~= nil or scope:match("^calcBg") ~= nil then return true else return false end
end

function isForegroundScope(scope)
	assert(type(scope) == "string" and string.len(scope) > 0, "scope is not a string or has zero length")
	if scope:match("^fg") ~= nil or scope:match("^calcFg") ~= nil then return true else return false end
end

function groupByPrefix(variables)
	local groups = {}

	for _, var in ipairs(variables) do
		local prefix = string.sub(var, 1, 2)
		if not groups[prefix] then
			groups[prefix] = {}
		end
		table.insert(groups[prefix], var)
	end

	return groups
end

function getBaseColorName(hsl)
	local hue = hsl.h
	if hsl.s < 21 then return "Gray"
	elseif (hue >= 0 and hue < 10) or (hue >= 320 and hue <= 359) then return "Red"
	elseif hue >= 10  and hue < 50  then return "Orange"
	elseif hue >= 50  and hue < 80  then return "Yellow"
	elseif hue >= 80  and hue < 160 then return "Green"
	elseif hue >= 160 and hue < 200 then return "Cyan"
	elseif hue >= 200 and hue < 250 then return "Blue"
	elseif hue >= 250 and hue < 270 then return "Violet"
	elseif hue >= 270 and hue < 290 then return "Purple"
	elseif hue >= 290 and hue < 320 then return "Pink"
	end
end

function saveTheme()
	local files = listFiles(settings.colorSchemesDir)
	if #files == 0 then
		print("Could not read files in " .. settings.colorSchemesDir)
		return
	end

	local baseColorName = getBaseColorName(settings.rulesMap[settings.baseScope])
	local prefix = settings.colorSchemePrefix .. baseColorName

	local maxNum = 0
	for _, file in ipairs(files) do
		local fileNameDigits = file:match(prefix .. "(%d+)%.vim")
		local num = tonumber(fileNameDigits)
		if num and num > maxNum then
			maxNum = num
		end
	end

	local newNum = maxNum + 1
	local fileBaseName = string.format("%s%02d", prefix, newNum)
	local themeFilePath = string.format("%s/%s.vim", settings.colorSchemesDir, fileBaseName)

	local list = { settings.colorSchemeText }
	local success, err = pcall(function()
		writeStringToFile(settings.colorSchemeText, themeFilePath)
	end)
	if not success then
		showMessage("Error: " .. err)
	else
		showMessage("Saved " .. themeFilePath)
	end
end

function writeStringToFile(content, filepath)
	if type(content) ~= "string" or string.len(content) == 0 then
		showError("writeStringToFile: content must be a non-empty string")
		return false
	end
	if type(filepath) ~= "string" or filepath == "" then
		showError("writeStringToFile: filepath must be a non-empty string")
		return false
	end

	local file, err = io.open(filepath, "w")
	if not file then
		showError("Failed to open file: " .. err)
		return false
	end

	file:write(content)
	file:close()

	return true
end

function stripHash(str)
	return str:gsub("#", "")
end

function applyColorScheme()
	local themeFilePath = settings.colorSchemesDir .. "/chromakeys.vim"

	local success, err = pcall(function()
		writeStringToFile(settings.colorSchemeText, themeFilePath)
	end)
	if not success then
		showMessage("Error: " .. err)
	else
		showMessage("Saved " .. themeFilePath .. " successfully")
		vim.cmd.colorscheme("chromakeys")
		-- vim.api.nvim_set_option_value("colorscheme", "chromakeys", {})
		showStatus()
	end
end

function getMaxWidth(arr)
	local maxWidth = 0
	for _, str in ipairs(arr) do
		maxWidth = math.max(string.len(str), maxWidth)
	end
	return maxWidth
end

function logInColumns(arr)
	local s = ""
	local screenWidth = vim.api.nvim_get_option_value("columns", {})
	local COLUMN_WIDTH = getMaxWidth(arr) + 2
	local numColumns = math.floor(screenWidth / COLUMN_WIDTH)
	for index, varName in ipairs(arr) do
		s = s .. padToWidth(varName, COLUMN_WIDTH)
		if index > 0 and index % numColumns == 0 then
			s = s .. "\n"
		end
	end
	print(s)
end

function showHighlightGroups()
	logInColumns(settings.allVars)
	print(#settings.allVars .. " highlight groups")
end

function getTemplateVars()
	local templateVars = extractVariables(colorSchemeTemplate)
	local groupedTemplateVars = groupByPrefix(templateVars)

	local fgVars
	local bgVars

	for prefix, group in pairs(groupedTemplateVars) do
		if prefix == "fg" then
			fgVars = group
		end
		if prefix == "bg" then
			bgVars = group
		end
	end

	return fgVars, bgVars
end

function resetBaseSaturationAndLightness()
	settings.base.s = 50
	settings.base.l = 50.25
	createDemoRules()
	createColorSchemeText()
	applyColorScheme()
end

function adjustHsl(hslValue, action, scope)
	assert(type(hslValue) == "table", "adjustHsl: hslValue is not a table")
	local h = hslValue.h
	local s = hslValue.s
	local l = hslValue.l
	local hueStep = settings.hueStep
	local saturationStep = settings.saturationStep
	local lightnessStep = settings.lightnessStep
	if action == ACTIONS.HUE_INCREASE then
		h = addHue(h, hueStep)
		if hueStep > 1 then h = math.floor(h / hueStep) * hueStep end
	elseif action == ACTIONS.HUE_DECREASE then
		h = addHue(h, -hueStep)
		if hueStep > 1 then h = math.floor(h / hueStep) * hueStep end
	elseif action == ACTIONS.SATURATION_INCREASE then
		s = math.min(s + saturationStep, 100)
		if saturationStep > 1 then s = math.floor(s / saturationStep) * saturationStep end
	elseif action == ACTIONS.SATURATION_DECREASE then
		s = math.max(s - saturationStep, 0)
		if saturationStep > 1 then s = math.floor(s / saturationStep) * saturationStep end
	elseif action == ACTIONS.LIGHTNESS_INCREASE then
		l = math.min(l + lightnessStep, settings.maxFgBrightness)
	elseif action == ACTIONS.LIGHTNESS_DECREASE then
		l = math.max(l - lightnessStep, 0)
	elseif action == ACTIONS.HUE_INCREASE_LARGE then
		h = math.floor(addHue(h, settings.hueCycleStep) / settings.hueCycleStep) * settings.hueCycleStep
	elseif action == ACTIONS.HUE_DECREASE_LARGE then
		h = math.floor(addHue(h, -settings.hueCycleStep) / settings.hueCycleStep) * settings.hueCycleStep
	elseif action == ACTIONS.SATURATION_INCREASE_LARGE then
		s = clamp(math.floor((s + 10) / 10) * 10, 0, 100)
	elseif action == ACTIONS.SATURATION_DECREASE_LARGE then
		s = clamp(math.floor((s - 10) / 10) * 10, 0, 100)
	elseif action == ACTIONS.LIGHTNESS_INCREASE_LARGE then
		l = clamp(math.floor((l + 10) / 10) * 10, 0, 100)
	elseif action == ACTIONS.LIGHTNESS_DECREASE_LARGE then
		l = clamp(math.floor((l - 10) / 10) * 10, 0, 100)
	elseif action == ACTIONS.RANDOMISE then
		h = math.random(0, 359)
		s = math.random(10, 90)
		l = isBackgroundScope(scope) and settings.backgroundLightness or math.random(settings.minFgBrightness, settings.maxFgBrightness)
	elseif action == ACTIONS.RANDOMISE_HUE then
		h = math.random(0, 359)
	elseif action == ACTIONS.RANDOMISE_SATURATION then
		s = math.random(20, 80)
	elseif action == ACTIONS.RANDOMISE_LIGHTNESS then
		l = math.random(settings.minFgBrightness, settings.maxFgBrightness)
	end
	return makeHsl(h, s, l)
end

function createAdjustmentCommand(command)
	return function()
		adjustCurrentScopeColor(command)
	end
end

function adjustCurrentScopeColor(action)
	if getTableLength(settings.rulesMap) == 0 then
		forceLog("adjustCurrentScopeColor: settings.rulesMap is empty")
		generateColorScheme()
	end
	local currentScope = settings.scopes:current()
	if currentScope == SPECIAL_SCOPES.BASE then
		setBaseColor(adjustHsl(settings.base, action, currentScope))
		createDemoRules()
	elseif currentScope == SPECIAL_SCOPES.ALL then
		for scope, currentColor in pairs(settings.rulesMap) do
			if scope ~= "bgNormal" then
				setScopeColor(scope, adjustHsl(currentColor, action, scope))
			end
		end
	elseif currentScope == SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL then
		for scope, currentColor in pairs(settings.rulesMap) do
			if scope ~= "fgNormal" and scope ~= "bgNormal" then
				setScopeColor(scope, adjustHsl(currentColor, action, scope))
			end
		end
	elseif currentScope == SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL_AS_ONE then
		local currentColor = settings.allExceptFgNormalAsOne
		local adjustedHsl = adjustHsl(currentColor, action, currentScope)
		for _, scope in ipairs(settings.fgVars) do
			if scope ~= "fgNormal" then
				setScopeColor(scope, adjustedHsl)
			end
		end
		settings.rulesMap.bgNormal = forceLightness(settings.rulesMap.bgNormal, settings.backgroundLightness)
		settings.allExceptFgNormalAsOne = adjustedHsl
	else
		setScopeColor(currentScope, adjustHsl(settings.rulesMap[currentScope], action, currentScope))
	end

	local scopesThatTriggerRecalculationOfDerivedColors = {
		[SPECIAL_SCOPES.BASE] = true,
		[SPECIAL_SCOPES.ALL] = true,
		[SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL] = true,
	}

	if scopesThatTriggerRecalculationOfDerivedColors[currentScope] then
		settings.shouldRecalculateDerivedColors = true
	else
		settings.shouldRecalculateDerivedColors = false
	end

	applyConstraintsToRules()
	createColorSchemeText()
	applyColorScheme()
end

function setBaseColor(hsl)
	settings.base = hsl
end

function setBackgroundColor(hsl)
	settings.backgroundLightness = hsl.l
	settings.backgroundSaturation = hsl.s
end

function setScopeColor(scope, hsl)
	settings.rulesMap[scope] = hsl
	if scope == settings.baseScope then
		deriveBgNormal()
		settings.base.h = settings.rulesMap[settings.baseScope].h
	elseif scope == "fgComment" then
		deriveBgCommentFromFgComment()
	elseif scope == "bgNormal" or scope == SPECIAL_SCOPES.ALL or scope == SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL or scope == SPECIAL_SCOPES.ALL_EXCEPT_FGNORMAL_AS_ONE then
		setBackgroundColor(settings.rulesMap.bgNormal)
	end
end

function forceBrightness(hslValue, desiredBrightness)
	local hexColor = hslToHex(hslValue)
	local actualBrightness = calcBrightnessHex(hexColor)
	local multiplier = actualBrightness > 0 and desiredBrightness / actualBrightness or 0
	local adjustedHexColor = multiplyHexColor(hexColor, multiplier)
	return hexToHsl(adjustedHexColor)
end

function adjustPerceptualBrightness(hsl)
	local hueKey = math.floor(hsl.h / 10) * 10
	local adjustmentLookup = {
		[210] = 4,
		[220] = 9,
		[230] = 12,
		[240] = 16,
		[250] = 14,
		[260] = 12,
		[270] = 11,
		[280] = 9,
	}
	local adjustment = adjustmentLookup[hueKey]
	if adjustment ~= nil then
		hsl.l = math.min(hsl.l + adjustment, 100)
	end
	return hsl
end

function forceLightness(hslValue, desiredLightness)
	return makeHsl(hslValue.h, hslValue.s, desiredLightness)
end

function clampSaturation(hslValue, min, max)
	return makeHsl(hslValue.h, clamp(hslValue.s, min, max), hslValue.l)
end

function clampLightness(hslValue, min, max)
	return makeHsl(hslValue.h, hslValue.s, clamp(hslValue.l, min, max))
end

function forceSaturation(hslValue, desiredSaturation)
	return makeHsl(hslValue.h, desiredSaturation, hslValue.l)
end

function limitChannelBrightness(hslValue, scope)
	local r, g, b = hslToRgb(hslValue)
	local brightestChannel = math.max(r, g, b)
	if brightestChannel > settings.maxChannelValue then
		local multiplier = settings.maxChannelValue / brightestChannel
		r = r * multiplier
		g = g * multiplier
		b = b * multiplier
		local hex = rgbToHex(r, g, b)
		local newHslValue = hexToHsl(hex)
		return newHslValue
	end
	return hslValue
end





function deriveBgNormal()
	setScopeColor("bgNormal", makeHsl(settings.rulesMap[settings.baseScope].h, settings.backgroundSaturation, settings.backgroundLightness))
end

function deriveBgCommentFromFgComment()
	setScopeColor("calcBgComment", forceLightness(settings.rulesMap.fgComment, settings.commentBgLightness))
end

function createRules()
	for i, varName in ipairs(settings.fgVars) do
		setScopeColor(varName, settings.fgColors[i])
	end
	local bgHue = settings.rulesMap[settings.baseScope].h
	for i, varName in ipairs(settings.bgVars) do
		setScopeColor(varName, makeHsl(bgHue, settings.backgroundSaturation, settings.backgroundLightness))
	end
	if settings.shouldLockFgNormalToBaseColor then
		setScopeColor("fgNormal", settings.base)
	end
	if settings.shouldAdjustPerceptualBrightness then
		for _, varName in ipairs(settings.fgVars) do
			settings.rulesMap[varName] = adjustPerceptualBrightness(settings.rulesMap[varName])
		end
	end
end

function createDemoRules()
	local fgColor = settings.base
	local bgColor = dimForBackground(fgColor)
	for _, varName in ipairs(settings.fgVars) do
		setScopeColor(varName, fgColor)
	end
	for _, varName in ipairs(settings.bgVars) do
		setScopeColor(varName, bgColor)
	end
	for _, varName in ipairs(SPECIAL_SCOPES) do
		setScopeColor(varName, fgColor)
	end
	applyConstraintsToRules()
end

function sanitizeScopeFromFile(scope)
	assert(type(scope) == "string", "sanitizeScopeFromFile: scope is not a string")
	return string.gsub(scope, "[-.]", "")
end

function createRulesFromScheme()
	local currentColorScheme = config.GetGlobalOption("colorscheme")
	local currentColorSchemeFile = settings.colorSchemesDir .. "/" .. currentColorScheme .. ".micro"

	local schemeVarsToSanitizedKeys = {
		default           = "fgNormal",
		statement         = "fgStatement",
		constant          = "fgConstant",
		constantstring    = "fgConstantString",
		constantregex     = "fgConstantRegex",
		comment           = "fgComment",
		identifier        = "fgIdentifier",
		preproc           = "fgPreproc",
		special           = "fgSpecial",
		symbol            = "fgSymbol",
		type              = "fgType",
		statusline        = "StatusLine",
		message           = "Message",
		linenumber        = "LineNumber",
		currentlinenumber = "CurrentLineNumber"
	}

	local colorTable = {}

	local data, err = ioutil.ReadFile(currentColorSchemeFile)

	if err ~= nil then
		showMessage("Chromakeys: Could not read file " .. currentColorSchemeFile)
		createDemoRules()
		return
	else
		log("Creating rules from color scheme " .. currentColorScheme)
		local fileDataAsString = fmt.Sprintf("%s", data)
		for line in fileDataAsString:gmatch("[^\r\n]+") do
			local scope, colors = line:match('color%-link%s+([%w%-%.]+)%s+"([^"]+)"')
			if scope then scope = sanitizeScopeFromFile(scope) end
			if scope and colors and schemeVarsToSanitizedKeys[scope] ~= nil then
				local sanitizedKey = schemeVarsToSanitizedKeys[scope]
				local scopeColors = {}
				for color in colors:gmatch("[^,]+") do
					local colorHex = color:gsub("bold ", "")
					colorHex = colorHex:gsub("#", "")
					table.insert(scopeColors, colorHex)
				end

				colorTable[sanitizedKey] = {}
				if #scopeColors == 1 then
					colorTable[sanitizedKey].fg = scopeColors[1]
				elseif #scopeColors == 2 then
					colorTable[sanitizedKey].fg = scopeColors[1]
					colorTable[sanitizedKey].bg = scopeColors[2]
				end
			end
		end
	end

	for sanitizedKey, colors in pairs(colorTable) do
		if sanitizedKey == "fgNormal" then
			settings.rulesMap.fgNormal = hexToHslWithFallback(colors.fg)
			settings.rulesMap.bgNormal = hexToHslWithFallback(colors.bg)
			setBackgroundColor(settings.rulesMap.bgNormal)
		elseif sanitizedKey == "fgComment" then
			settings.rulesMap.fgComment = hexToHslWithFallback(colors.fg)
			settings.rulesMap.calcBgComment = hexToHslWithFallback(colors.bg)
		elseif sanitizedKey == "StatusLine" then
			settings.rulesMap.calcFgStatusLine = hexToHslWithFallback(colors.fg)
			settings.rulesMap.calcBgStatusLine = hexToHslWithFallback(colors.bg)
		elseif sanitizedKey == "Message" then
			settings.rulesMap.calcFgMessage = hexToHslWithFallback(colors.fg)
		elseif sanitizedKey == "LineNumber" then
			settings.rulesMap.calcFgLineNumber = hexToHslWithFallback(colors.fg)
		elseif sanitizedKey == "CurrentLineNumber" then
			settings.rulesMap.calcFgCurrentLineNumber = hexToHslWithFallback(colors.fg)
		else
			settings.rulesMap[sanitizedKey] = hexToHslWithFallback(colors.fg)
		end
	end

	log("Original rules:")
	logRules()
	settings.originalRulesMaxChannelValue = getMaxChannelValue(settings.rulesMap)
	limitChannelBrightnessForAllRules()
	log("Rules after limiting channel brightness:")
	logRules()
	createColorSchemeText()
	setBaseColor(settings.rulesMap.fgNormal)
end

function isValidHsl(value)
	return type(value) == "table" and value.h ~= nil and value.s ~= nil and value.l ~= nil
end

function isValidHex(value)
	return type(value) == "string" and string.len(value) == 6
end

function checkRulesValidity()
	for _, scope in ipairs(settings.fgVars) do
		if settings.rulesMap[scope] == nil then
			log(scope .. " is nil")
			return false
		elseif not isValidHsl(settings.rulesMap[scope]) then
			log(string.format("checkRulesValidity: settings.rulesMap[%s] is not an HSL value", scope))
			return false
		end
	end
	return true
end

function ensureFgBgLightness()
	for _, scope in ipairs(settings.fgVars) do
		settings.rulesMap[scope] = clampLightness(settings.rulesMap[scope], settings.minFgBrightness, settings.maxFgBrightness)
	end
	for _, scope in ipairs(settings.bgVars) do
		settings.rulesMap[scope] = clampLightness(settings.rulesMap[scope], 0, settings.maxBgBrightness)
	end
	return true
end

function applyConstraintsToRules()
	local areRulesValid = checkRulesValidity()
	if not areRulesValid then
		log("applyConstraintsToRules: rules are not valid, returning")
		return
	end

	ensureFgBgLightness()

	local fg = settings.rulesMap[settings.baseScope]
	local bg = settings.rulesMap.bgNormal

	if settings.shouldRecalculateDerivedColors then
		settings.rulesMap.fgComment = makeHsl(settings.rulesMap.fgComment.h, 65, 75)
		settings.rulesMap.bgComment = makeHsl(settings.rulesMap.fgComment.h, 65, 15)
		settings.rulesMap.fgStatusLine = clampSaturation(forceLightness(fg, 45), 0, 35)
		-- settings.rulesMap.fgNormal = clampSaturation(forceLightness(fg, 45), 0, 35)
		settings.rulesMap.bgStatusLine = clampSaturation(forceLightness(fg, 4), 0, 35)
		settings.rulesMap.bgStatusLine.l = math.min(settings.rulesMap.bgStatusLine.l, bg.l)
		settings.rulesMap.fgLineNr = makeHsl(fg.h, 30, 35)
		settings.rulesMap.fgCursorLineNr = makeHsl(fg.h, 50, 60)
		settings.rulesMap.bgLineNr = settings.rulesMap.bgStatusLine
		settings.rulesMap.bgCursorLineNr = settings.rulesMap.bgStatusLine

		settings.rulesMap.fgSpecial = makeHsl(settings.rulesMap.fgStatement.h, 100, 50)
		settings.rulesMap.fgEndOfBuffer = makeHsl(0, 0, 0)
		settings.rulesMap.bgEndOfBuffer = makeHsl(0, 0, 0)

		settings.rulesMap.fgCurSearch = makeHsl(0, 0, 75)
		settings.rulesMap.bgCurSearch = makeHsl(0, 0, 0)
		settings.rulesMap.fgSearch = makeHsl(145, 70, 50)
		settings.rulesMap.bgSearch = makeHsl(145, 60, 30)

		settings.rulesMap.fgDiffAdd = makeHsl(150, 80, 50)
		settings.rulesMap.bgDiffAdd = makeHsl(150, 30, 30)
		settings.rulesMap.fgDiffDelete = makeHsl(0, 80, 50)
		settings.rulesMap.bgDiffDelete = makeHsl(0, 30, 30)
		settings.rulesMap.fgDiffChange = makeHsl(220, 80, 60)
		settings.rulesMap.bgDiffChange = makeHsl(220, 30, 30)

		settings.rulesMap.fgDiagnosticError = makeHsl(0, 50, 50)
		settings.rulesMap.bgDiagnosticError = makeHsl(0, 20, 20)
		settings.rulesMap.fgDiagnosticWarn = makeHsl(30, 50, 50)
		settings.rulesMap.bgDiagnosticWarn = makeHsl(30, 20, 20)
		settings.rulesMap.fgDiagnosticOk = makeHsl(130, 50, 50)
		settings.rulesMap.bgDiagnosticOk = makeHsl(130, 20, 20)
		settings.rulesMap.fgDiagnosticInfo = makeHsl(230, 50, 50)
		settings.rulesMap.bgDiagnosticInfo = makeHsl(230, 20, 20)
		settings.rulesMap.fgDiagnosticHint = makeHsl(30, 50, 50)
		settings.rulesMap.bgDiagnosticHint = makeHsl(30, 20, 20)

		settings.rulesMap.fgVisual = makeHsl(settings.rulesMap.fgVisual.h, 80, 70)
		settings.rulesMap.bgVisual = makeHsl(settings.rulesMap.fgVisual.h, 80, 35)

		settings.rulesMap.fgPmenu = makeHsl(settings.rulesMap.fgPmenu.h, 20, 50)
		settings.rulesMap.bgPmenu = makeHsl(settings.rulesMap.fgPmenu.h, 0, 0)
		settings.rulesMap.fgPmenuSel = makeHsl(settings.rulesMap.fgPmenuSel.h, 60, 75)
		settings.rulesMap.bgPmenuSel = makeHsl(settings.rulesMap.fgPmenuSel.h, 20, 20)

		settings.rulesMap.fgModeMsg = makeHsl(fg.h, 50, 50)
		settings.rulesMap.bgModeMsg = makeHsl(fg.h, 20, 20)

		settings.rulesMap.fgMoreMsg = makeHsl(fg.h, 50, 50)
		settings.rulesMap.bgMoreMsg = makeHsl(fg.h, 20, 20)

		settings.rulesMap.fgStatusLineNC = makeHsl(settings.rulesMap.bgStatusLine.h, 30, 35)
		settings.rulesMap.bgStatusLineNC = makeHsl(0, 0, 0)

		settings.rulesMap.bgSignColumn = settings.rulesMap.bgLineNr

		settings.rulesMap.fgUnderlined = makeHsl(60, 50, 50)
		settings.rulesMap.bgUnderlined = makeHsl(0, 0, 0)
	end

	if settings.shouldForceUniformBrightness then
		for _, varName in ipairs(settings.fgVarsThatShouldBeBright) do
			settings.rulesMap[varName] = forceBrightness(settings.rulesMap[varName], settings.uniformBrightness)
		end
	end

	if settings.shouldEnsureSeparation then
		ensureSeparationFromDefault("fgStatement", "fgConstant")
	end

	if settings.shouldLimitChannelValues then
		limitChannelBrightnessForAllRules()
	end

	logRules()
end

function limitChannelBrightnessForAllRules()
	for scope, _ in pairs(settings.rulesMap) do
		if isBackgroundScope(scope) then
			settings.rulesMap[scope] = clampLightness(settings.rulesMap[scope], 0, settings.maxBgBrightness)
		else
			settings.rulesMap[scope] = limitChannelBrightness(settings.rulesMap[scope], scope)
		end
	end
end

function createColorSchemeText()
	settings.colorSchemeText = replaceVariables(colorSchemeTemplate, settings.rulesMap)
end





function generateColorsByPalette(paletteName)
	return function(numColors)
		local hues = settings.palettes[paletteName]
		local colorsPerHue = math.ceil(numColors / #hues)
		local colors = {}
		local s = settings.base.s
		local l = settings.base.l
		local hVariance = 10
		local sVariance = 30
		local lVariance = 30
		for _, hue in ipairs(hues) do
			for _ = 1, colorsPerHue do
				local hFinal = addHue(hue, math.random(0, hVariance))
				local sFinal = clamp(s + (math.random(0, sVariance) - sVariance * 0.5), 0, 100)
				local lFinal = clamp(l + (math.random(0, lVariance) - lVariance * 0.5), 0, 100)
				table.insert(colors, makeHsl(hFinal, sFinal, lFinal))
				if #colors == numColors then break end
			end
			if #colors == numColors then break end
		end
		shuffle(colors)
		return colors
	end
end

function generateColorsByPalette_BaseSL(paletteName)
	return function(numColors)
		local hues = settings.palettes[paletteName]
		local colorsPerHue = math.ceil(numColors / #hues)
		local colors = {}
		for _, hue in ipairs(hues) do
			for _ = 1, colorsPerHue do
				local h = addHue(hue, math.random(0, 10))
				local s = clamp(math.random(settings.base.s - 10, settings.base.s + 10), 0, 100)
				local l = clamp(math.random(settings.base.l - 10, settings.base.l + 10), 0, 100)
				table.insert(colors, makeHsl(h, s, l))
				if #colors == numColors then break end
			end
			if #colors == numColors then break end
		end
		shuffle(colors)
		return colors
	end
end

function generateColorsByPalette_CyclicHL(paletteName)
	return function(numColors)
		local hues = settings.palettes[paletteName]
		local step = (#hues / numColors) * 1.7
		local huePoint = 1
		local colors = {}
		while true do
			local intValue = math.floor(huePoint)
			local remainder = huePoint - intValue
			local h = intValue < #hues and math.floor(hues[intValue] + (10 * remainder)) or 333
			local x = settings.generationCount
			local s = math.floor(100 * (0.5 + (0.25 *  math.sin(x * math.pi * 0.025))))
			local l = math.floor(100 * (0.5 + (0.25 *  math.sin(x * math.pi * 0.050))))
			table.insert(colors, makeHsl(h, s, l))
			if #colors == numColors then break end
			x = x + 1
			s = math.floor(100 * (0.5 + (0.25 *  math.sin(x * math.pi * 0.025))))
			l = math.floor(100 * (0.5 + (0.25 *  math.sin(x * math.pi * 0.050))))
			table.insert(colors, makeHsl(h, s, l))
			if #colors == numColors then break end
			huePoint = huePoint + step
		end
		shuffle(colors)
		return colors
	end
end

function generateColorsByAdjacentHues(numColors)
	if numColors < 1 then return {} end

	local colors = {}
	local hue = math.random(0, 359)
	local saturation = math.random(math.min(settings.base.s, 70), 90)
	local lightness = math.random(math.min(settings.base.l, 60), 70)
	local hueStep = math.random(1, 3)

	for _ = 0, numColors - 1 do
		hue = addHue(hue, hueStep)
		table.insert(colors, makeHsl(hue, saturation, lightness))
	end

	return colors
end

function generateColorsByAdjacentHuesBaseSL(numColors)
	if numColors < 1 then return {} end

	local colors = {}
	local hue = math.random(0, 359)
	local saturation = settings.base.s
	local lightness = settings.base.l
	local hueStep = math.random(1, 3)

	for _ = 0, numColors - 1 do
		hue = addHue(hue, hueStep)
		table.insert(colors, makeHsl(hue, saturation, lightness))
	end

	return colors
end

function generateColorsByAdjacentHuesMild(numColors)
	if numColors < 1 then return {} end

	local colors = {}
	local hue = math.random(0, 359)
	local saturation = 30
	local lightness = 55
	local hueStep = math.random(1, 3)

	for _ = 0, numColors - 1 do
		hue = addHue(hue, hueStep)
		table.insert(colors, makeHsl(hue, saturation, lightness))
	end

	return colors
end

function generateColorsByAdjacentHuesVivid(numColors)
	if numColors < 1 then return {} end

	local colors = {}
	local hue = math.random(0, 359)
	local saturation = 60
	local lightness = 50
	local hueStep = math.random(1, 3)

	for _ = 0, numColors - 1 do
		hue = addHue(hue, hueStep)
		table.insert(colors, makeHsl(hue, saturation, lightness))
	end

	return colors
end

function generateColorsByRandomHue(numColors)
	if numColors < 1 then return {} end

	local colors = {}
	for _ = 1, numColors do
		local hue = math.random(0, 359)
		table.insert(colors, makeHsl(hue, settings.base.s, settings.base.l))
	end

	return colors
end

function generateColorsByRandomHueAndLightness(numColors)
	if numColors < 1 then return {} end
	local colors = {}
	for _ = 1, numColors do
		local hue = math.random(0, 359)
		table.insert(colors, makeHsl(hue, settings.base.s, math.random(settings.minFgBrightness, settings.maxFgBrightness)))
	end
	return colors
end

function generateColorsByRandomSaturation(numColors)
	if numColors < 1 then return {} end
	local colors = {}
	for _ = 1, numColors do
		table.insert(colors, makeHsl(settings.base.h, math.random(20, 90), settings.base.l))
	end
	return colors
end

function generateColorsByRandomLightness(numColors)
	if numColors < 1 then return {} end
	local colors = {}
	for _ = 1, numColors do
		table.insert(colors, makeHsl(settings.base.h, settings.base.s, math.random(20, 65)))
	end
	return colors
end

function generateColorsBySteppedLightness(numColors)
	if numColors < 1 then return {} end
	local colors = {}
	local lightnessRange = 65 - settings.minFgBrightness
	local step = lightnessRange / numColors
	local lightness = settings.minFgBrightness
	for _ = 1, numColors do
		table.insert(colors, makeHsl(settings.base.h, settings.base.s, lightness))
		lightness = lightness + step
	end
	shuffle(colors)
	return colors
end

function generateColorsByShadesOfBaseHue(numColors)
	if numColors < 1 then return {} end
	local colors = {}
	for _ = 1, numColors do
		table.insert(colors, makeHsl(settings.base.h, settings.base.s, math.random(20, 70)))
	end
	return colors
end

function generateColorsByShadesOfRandomHue(numColors)
	if numColors < 1 then return {} end
	local hue = math.random(0, 359)
	local colors = {}
	for _ = 1, numColors do
		table.insert(colors, makeHsl(hue, math.random(20, 90), math.random(20, 90)))
	end
	return colors
end

function generateColorsByShadesOfCyclicHue(numColors)
	if numColors < 1 then return {} end
	local hue = math.floor(settings.generationCount * 2 % 360)
	local colors = {}
	for _ = 1, numColors do
		table.insert(colors, makeHsl(hue, math.random(20, 90), math.random(20, 90)))
	end
	return colors
end

function generateColorsByRandomHueAndSaturation(numColors)
	if numColors < 1 then return {} end
	local colors = {}
	for _ = 1, numColors do
		local hue = math.random(0, 359)
		table.insert(colors, makeHsl(hue, math.random(20, 90), settings.base.l))
	end
	return colors
end





function initScopeCycler()
	settings.scopes = Cyclable.new(settings.fgVars)
	for _, scope in ipairs(settings.bgVars) do
		settings.scopes:add(scope)
	end
	for _, scope in ipairs(SPECIAL_SCOPES_ORDER) do
		settings.scopes:addAndSelect(SPECIAL_SCOPES[scope])
	end
end

function M.previousScope()
	settings.scopes:previous()
	showStatus()
end

function M.nextScope()
	settings.scopes:next()
	showStatus()
end

function getMatchingStrings(array, str)
	local matches = {}
	for _, scope in ipairs(array) do
		if string.match(string.lower(scope), str) then
			table.insert(matches, scope)
		end
	end
	return matches
end

function M.setScope(str)
	local matchingScopes = getMatchingStrings(settings.allVars, string.lower(str))
	if #matchingScopes == 1 then
		settings.scopes:select(matchingScopes[1])
		showStatus()
	else
		local s = ""
		for _, scope in ipairs(matchingScopes) do
			s = s .. scope .. " "
		end
		print("matching scopes: " .. s)
	end
end

function initColorFuncCycler()
	settings.colorFunctions = Cyclable.new({})
	local paletteNames = {}
	for paletteName, _ in pairs(settings.palettes) do
		table.insert(paletteNames, paletteName)
	end
	table.sort(paletteNames)

	for _, paletteName in ipairs(paletteNames) do
		settings.colorFunctions:add({ paletteName, generateColorsByPalette(paletteName) })
	end

	settings.colorFunctions:add({ "RandomSaturation",       generateColorsByRandomSaturation       })
	settings.colorFunctions:add({ "RandomHueAndLightness",  generateColorsByRandomHueAndLightness  })
	settings.colorFunctions:add({ "RandomHue",              generateColorsByRandomHue              })
	settings.colorFunctions:add({ "RandomHueAndSaturation", generateColorsByRandomHueAndSaturation })
	settings.colorFunctions:add({ "AdjacentHues",           generateColorsByAdjacentHues           })
	settings.colorFunctions:add({ "AdjacentHuesBaseSL",     generateColorsByAdjacentHuesBaseSL     })
	settings.colorFunctions:add({ "AdjacentHuesMild",       generateColorsByAdjacentHuesMild       })
	settings.colorFunctions:add({ "AdjacentHuesVivid",      generateColorsByAdjacentHuesVivid      })
	settings.colorFunctions:add({ "ShadesOfCyclicHue",      generateColorsByShadesOfCyclicHue      })
	settings.colorFunctions:add({ "ShadesOfBaseHue",        generateColorsByShadesOfBaseHue        })
	settings.colorFunctions:add({ "ShadesOfRandomHue",      generateColorsByShadesOfRandomHue      })
	settings.colorFunctions:add({ "RandomLightness",        generateColorsByRandomLightness        })
	settings.colorFunctions:add({ "SteppedLightness",       generateColorsBySteppedLightness       })
end

function previousColorFunction()
	settings.colorFunctions:previous()
	generateColorScheme()
	showStatus()
end

function nextColorFunction()
	settings.colorFunctions:next()
	generateColorScheme()
	showStatus()
end

function generateColorScheme()
	settings.shouldRecalculateDerivedColors = true
	local colorGenFunc = settings.colorFunctions:current()[2]
	settings.fgColors = colorGenFunc(#settings.fgVars)
	createRules()
	applyConstraintsToRules()
	createColorSchemeText()
	applyColorScheme()
	settings.generationCount = settings.generationCount + 1
end





function listFiles(dir)
	if vim.fn.isdirectory(dir) == 0 then
		print("Directory does not exist: " .. dir)
		return {}
	end

	return vim.fn.readdir(dir)
end

function printIndented(arrStrings, indentLevel)
	local indentStr = indentLevel ~= nil and string.rep("\t", indentLevel) or ""
	for _, str in ipairs(arrStrings) do
		print(indentStr .. str)
	end
end

function showInfo()
	local runtimePaths = vim.api.nvim_list_runtime_paths()
	print("runtime paths:")
	printIndented(runtimePaths, 1)
	local currentFilePath = vim.api.nvim_buf_get_name(0)
	print("\ncurrent file path: " .. currentFilePath)
	local homeDir = vim.fn.expand('~')
	local colorSchemesDir = homeDir .. "/.config/nvim/colors"
	print("\ncolor schemes dir: " .. colorSchemesDir)

	local files = listFiles(colorSchemesDir)
	printIndented(files, 1)
end

function setColorSchemesDir()
	local homeDir = vim.fn.expand('~')
	settings.colorSchemesDir = homeDir .. "/.config/nvim/colors"
end




function init()
	setColorSchemesDir()
	loadAvailableColorSchemes()
	setTemplateVariables()
	initScopeCycler()
	initColorFuncCycler()
	createDemoRules()
	createColorSchemeText()
end

init()

M.generateColorScheme     = generateColorScheme
M.previousColorFunction   = previousColorFunction
M.nextColorFunction       = nextColorFunction
M.increaseHue             = createAdjustmentCommand(ACTIONS.HUE_INCREASE)
M.decreaseHue             = createAdjustmentCommand(ACTIONS.HUE_DECREASE)
M.increaseHueLarge        = createAdjustmentCommand(ACTIONS.HUE_INCREASE_LARGE)
M.decreaseHueLarge        = createAdjustmentCommand(ACTIONS.HUE_DECREASE_LARGE)
M.increaseSaturation      = createAdjustmentCommand(ACTIONS.SATURATION_INCREASE)
M.decreaseSaturation      = createAdjustmentCommand(ACTIONS.SATURATION_DECREASE)
M.increaseSaturationLarge = createAdjustmentCommand(ACTIONS.SATURATION_INCREASE_LARGE)
M.decreaseSaturationLarge = createAdjustmentCommand(ACTIONS.SATURATION_DECREASE_LARGE)
M.increaseLightness       = createAdjustmentCommand(ACTIONS.LIGHTNESS_INCREASE)
M.decreaseLightness       = createAdjustmentCommand(ACTIONS.LIGHTNESS_DECREASE)
M.increaseLightnessLarge  = createAdjustmentCommand(ACTIONS.LIGHTNESS_INCREASE_LARGE)
M.decreaseLightnessLarge  = createAdjustmentCommand(ACTIONS.LIGHTNESS_DECREASE_LARGE)
M.randomizeColor          = createAdjustmentCommand(ACTIONS.RANDOMISE)
M.randomiseHue            = createAdjustmentCommand(ACTIONS.RANDOMISE_HUE)
M.randomiseSaturation     = createAdjustmentCommand(ACTIONS.RANDOMISE_SATURATION)
M.randomiseLightness      = createAdjustmentCommand(ACTIONS.RANDOMISE_LIGHTNESS)
M.previousColorScheme     = previousColorScheme
M.nextColorScheme         = nextColorScheme
M.showHighlightGroups     = showHighlightGroups
M.showInfo                = showInfo
M.saveTheme               = saveTheme

return M
