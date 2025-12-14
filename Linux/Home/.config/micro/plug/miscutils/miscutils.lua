local micro = import("micro")
local config = import("micro/config")
local buffer = import("micro/buffer")
local util = import("micro/util")
local ioutil = import("ioutil")
local os = import("os")
local filepath = import("filepath")
local time = import("time")

local settings = {
	filesInCurrentDir = {}
}

function showMessage(s)
	micro.InfoBar():Message(s)
end

function forceLog(arg)
	if type(arg) ~= "string" then arg = tostring(arg) end
	buffer.Log(arg .. "\n")
end

function logTable(tableInstance, indentLevel)
	assert(type(tableInstance) == "table", "Expected table, received " .. type(tableInstance))
	if not indentLevel then indentLevel = 0 end
	for key, value in pairs(tableInstance) do
		local indentString = string.rep("\t", indentLevel) .. key .. " = "
	  	if type(value) == "table" then
			forceLog(indentString .. "(table)")
			logTable(value, indentLevel + 1)
	  	elseif type(value) == nil then
			forceLog(indentString .. " nil")
		else
			forceLog(indentString .. tostring(value))
		end
	end
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

function collapseWhitespace(bp)
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

function padToWidth(str, width)
	local len = string.len(str)
	if len > width then return str end
	return str .. string.rep(" ", width - len)
end

function logColumnAligned(tbl)
	local columnWidths = {}

	for key, value in pairs(tbl) do
		table.insert(columnWidths, 0)
	end

	for key, value in pairs(tbl) do
		columnWidths[1] = math.max(columnWidths[1], string.len(key))
		columnWidths[2] = math.max(columnWidths[1], string.len(value))
	end

	for key, value in pairs(tbl) do
		forceLog(string.format("%s %s", padToWidth(key, columnWidths[1] + 4), value))
	end
end

function showCurDir(bp)
	local currentDir = os.Getwd()
	local openFileDir = filepath.Dir(bp.Buf.Path)
	local openFileBaseName = filepath.Base(bp.Buf.Path)

	forceLog("")
	logColumnAligned({
		["Current dir"] = currentDir,
		["bp.Buf.path"] = bp.Buf.Path,
		["openFileDir"] = openFileDir,
		["openFileBaseName"] = openFileBaseName
	})
end

function getFileListForDir(dir)
	local fileNames = {}
	local files, err = ioutil.ReadDir(dir)
	if err ~= nil then
		showMessage("Error reading directory " .. openFileDir)
	else
		for i = 1, #files do
			local fileName = files[i]:Name()
			table.insert(fileNames, fileName)
		end
	end

	forceLog(string.format("Found %d files", #files))

	settings.filesInCurrentDir = fileNames
end

function openPreviousFile(bp)
	local currentFileDir = filepath.Dir(bp.Buf.Path)
	local currentFileName = filepath.Base(bp.Buf.Path)

	if #settings.filesInCurrentDir == 0 then
		getFileListForDir(currentFileDir)
	end

	if #settings.filesInCurrentDir > 0 then
		local previousFileName = getPreviousString(settings.filesInCurrentDir, currentFileName)
		if previousFileName ~= nil then
			local previousFileFullPath = currentFileDir .. "/" .. previousFileName
			local buf, err = buffer.NewBufferFromFile(previousFileFullPath)
			if err == nil then
				bp:OpenBuffer(buf)
			end
		end
	end
end

function openNextFile(bp)
	local currentFileDir = filepath.Dir(bp.Buf.Path)
	local currentFileName = filepath.Base(bp.Buf.Path)

	if #settings.filesInCurrentDir == 0 then
		getFileListForDir(currentFileDir)
	end

	if #settings.filesInCurrentDir > 0 then
		local nextFileName = getNextString(settings.filesInCurrentDir, currentFileName)
		if nextFileName ~= nil then
			local nextFileFullPath = currentFileDir .. "/" .. nextFileName
			local buf, err = buffer.NewBufferFromFile(nextFileFullPath)
			if err == nil then
				bp:OpenBuffer(buf)
			end
		end
	end
end

function insertTimestamp(bp)
	local curPaneBuf = bp.Buf
	local numCursors = curPaneBuf:NumCursors()
	for i = 0, numCursors - 1 do
		local cursor = curPaneBuf:GetCursor(i)
		local cursorPos = buffer.Loc(cursor.Loc.X, cursor.Loc.Y)
		local timestamp = time.Now():Format("2006-01-02 15:04")
		bp.Buf:insert(cursorPos, timestamp)
	end
end

function init()
	config.MakeCommand("muInsertNumbersInColumn",    insertNumbersInColumn,               config.NoComplete)
	config.MakeCommand("muToggleSyntaxHighlighting", toggleBooleanOption("syntax"),       config.NoComplete)
	config.MakeCommand("muToggleWordWrap",           toggleBooleanOption("softwrap"),     config.NoComplete)
	config.MakeCommand("muToggleCaseSensitivity",    toggleBooleanOption("ignorecase"),   config.NoComplete)
	config.MakeCommand("muToggleHltaberrors",        toggleBooleanOption("hltaberrors"),  config.NoComplete)
	config.MakeCommand("muToggleHltrailingws",       toggleBooleanOption("hltrailingws"), config.NoComplete)
	config.MakeCommand("muShowKeyIsUnbound",         showKeyIsUnbound,                    config.NoComplete)
	config.MakeCommand("muShowUnboundKeys",          showUnboundKeysInBindingsJson,       config.NoComplete)
	config.MakeCommand("muCollapseWhitespace",       collapseWhitespace,                  config.NoComplete)
	config.MakeCommand("muShowCurrentDir",           showCurDir,                          config.NoComplete)
	config.MakeCommand("muOpenNextFile",             openNextFile,                        config.NoComplete)
	config.MakeCommand("muOpenPreviousFile",         openPreviousFile,                    config.NoComplete)
	config.MakeCommand("muTimestamp",                insertTimestamp,                     config.NoComplete)
end
