local micro = import("micro")
local config = import("micro/config")
local buffer = import("micro/buffer")
local util = import("micro/util")

function showMessage(s)
	micro.InfoBar():Message(s)
end

function forceLog(arg)
	if type(arg) ~= "string" then arg = tostring(arg) end
	buffer.Log(arg .. "\n")
end

function insertNumbersInColumn(bp)
	local curPaneBuf = bp.Buf
	local numCursors = curPaneBuf:NumCursors()
	for i = 0, numCursors - 1 do
		local cursor = curPaneBuf:GetCursor(i)
		local cursorPos = buffer.Loc(cursor.Loc.X, cursor.Loc.Y)
		bp.Buf:insert(cursorPos, string.format("%02d", i))
	end
end

function toggleBooleanOption(optionName)
	return function()
		config.SetGlobalOption(optionName, tostring(not config.GetGlobalOption(optionName)))
		showMessage(string.format("%s: %s", optionName, config.GetGlobalOption(optionName)))
	end
end

function showKeyIsUnbound()
	showMessage("unbound")
end

function stringToCharList(str)
    local chars = {}
    for char in str:gmatch('.') do
        table.insert(chars, char)
    end
    return chars
end

function showUnboundKeysInBindingsJson()
	local keys = stringToCharList("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ")
	for _, key in ipairs(keys) do
		config.TryBindKey("Alt-" .. key, "command:showKeyIsUnbound", false)
	end
	local ctrlKeys = stringToCharList("bdjklmnprtuw")
	for _, key in ipairs(ctrlKeys) do
		config.TryBindKey("Ctrl-" .. key, "command:showKeyIsUnbound", false)
	end
end

function flattenWhitespace(bp)
	local cursor = bp.Cursor
	if cursor and cursor:HasSelection() then
		local selectionString = util.String(cursor:GetSelection())
		selectionString = string.gsub(selectionString, "%s+", " ")
		cursor:DeleteSelection()
		cursor:ResetSelection()
		local cursorPosition = buffer.Loc(cursor.X, cursor.Y)
		bp.Buf:insert(cursorPosition, selectionString)
	end
end

function init()
	config.MakeCommand("insertNumbersInColumn",    insertNumbersInColumn,               config.NoComplete)
	config.MakeCommand("toggleSyntaxHighlighting", toggleBooleanOption("syntax"),       config.NoComplete)
	config.MakeCommand("toggleWordWrap",           toggleBooleanOption("softwrap"),     config.NoComplete)
	config.MakeCommand("toggleCaseSensitivity",    toggleBooleanOption("ignorecase"),   config.NoComplete)
	config.MakeCommand("toggleHltaberrors",        toggleBooleanOption("hltaberrors"),  config.NoComplete)
	config.MakeCommand("toggleHltrailingws",       toggleBooleanOption("hltrailingws"), config.NoComplete)
	config.MakeCommand("showKeyIsUnbound",         showKeyIsUnbound,                    config.NoComplete)
	config.MakeCommand("showUnboundKeys",          showUnboundKeysInBindingsJson,       config.NoComplete)
	config.MakeCommand("flattenWhitespace",        flattenWhitespace,                   config.NoComplete)
end
