local utils = require 'mp.utils'
local msg = require 'mp.msg'

local presets01 = {
	{ "Curve/Curve_06.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_16.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_26.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_29.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_06.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_16.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_26.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_29.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_06.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_16.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_26.glsl", "Blue/Blue_00.glsl" },
	{ "Curve/Curve_29.glsl", "Blue/Blue_00.glsl" },
}

local shaderGroupsByKey = {
	q = 'Blue',
	w = 'Psychedelic',
	e = 'RedBlue',
	r = 'Red',
	t = 'Tint',
	y = 'Green',
	u = 'LightTint',
	i = 'Invert',
	o = 'ChannelMixer',
	p = 'ColorRamp',
	a = 'Bright',
	s = 'Dim',
	d = 'Saturate',
	f = 'SaturateSelective',
	F = 'FilmicCurve',
	g = 'Grayscale',
	h = 'Blend',
	k = 'Curve',
	z = 'ExperimentalZ',
	x = 'ExperimentalX',
	c = 'ExperimentalC',
	C = 'Crop',
	v = 'OrangeBlue',
	b = 'MonotoneSepia',
	n = 'MonotoneRed',
	m = 'MonotoneBlue',

	j = 'seek',
	E = 'equalizer',
}

local equalizerPresets = {
	"",
	"equalizer=f=1000:t=o:w=1:g=-6,equalizer=f=12000:t=o:w=3:g=-24",
	"equalizer=f=500:t=o:w=2:g=-6,equalizer=f=1000:t=o:w=2:g=-6,equalizer=f=4000:t=o:w=2:g=-9,equalizer=f=8000:t=o:w=3:g=-24",
	"equalizer=f=500:t=o:w=1:g=-18,equalizer=f=1000:t=o:w=1:g=-18,equalizer=f=2000:t=o:w=1:g=-18,equalizer=f=4000:t=o:w=1:g=-18,equalizer=f=8000:t=o:w=1:g=-18,equalizer=f=16000:t=o:w=1:g=-18",
	"equalizer=f=500:t=o:w=1:g=-6,equalizer=f=1000:t=o:w=1:g=-12,equalizer=f=2000:t=o:w=1:g=-12,equalizer=f=4000:t=o:w=1:g=-12,equalizer=f=8000:t=o:w=1:g=-12,equalizer=f=16000:t=o:w=1:g=-12",
	"equalizer=f=500:t=o:w=1:g=-6,equalizer=f=1000:t=o:w=1:g=-6,equalizer=f=2000:t=o:w=1:g=-12,equalizer=f=4000:t=o:w=1:g=-12,equalizer=f=8000:t=o:w=1:g=-12,equalizer=f=16000:t=o:w=1:g=-12",
	"equalizer=f=500:t=o:w=1:g=-6,equalizer=f=1000:t=o:w=1:g=-6,equalizer=f=2000:t=o:w=1:g=-9,equalizer=f=4000:t=o:w=1:g=-12,equalizer=f=8000:t=o:w=1:g=-12,equalizer=f=16000:t=o:w=1:g=-12",
	"equalizer=f=500:t=o:w=1:g=-3,equalizer=f=1000:t=o:w=1:g=-6,equalizer=f=2000:t=o:w=1:g=-9,equalizer=f=4000:t=o:w=1:g=-9,equalizer=f=8000:t=o:w=1:g=-12,equalizer=f=16000:t=o:w=1:g=-12",
}

local settings = {
	fileTypesToHandle = {
		jpg = true,
		jpeg = true,
		png = true,
		gif = true,
		webp = true,
		bmp = true,
		mp3 = true,
		wav = true,
		ogm = true,
		flac = true,
		m4a = true,
		wma = true,
		ogg = true,
		opus = true,
		mkv = true,
		avi = true,
		mp4 = true,
		ogv = true,
		webm = true,
		rmvb = true,
		flv = true,
		wmv = true,
		mpeg = true,
		mpg = true,
		m4v = true,
		m2ts = true,
		mov = true,
		psd = true,
		aac = true,
	},
	fileList = {},
	dir = "",
	orderByNaturalNumbers = false,
	orderBySize = false,

	shadersDir = mp.command_native({"expand-path", "~~home/"}) .. "/shaders",
	shaderGroup = "Curve",
	shaderDigits = "00",
	shaderIndexByFileName = {},
	pass1 = "",
	pass2 = "",
	whichPass = "pass2",
	shadersGrouped = {},
	shaderCountsByGroup = {},
	shaderPresets = {},
}

function deepCopy(original)
    local copy
    if type(original) == "table" then
        copy = {}
        for k, v in next, original, nil do
            copy[deepCopy(k)] = deepCopy(v)
        end
        setmetatable(copy, deepCopy(getmetatable(original)))
    else
        copy = original
    end
    return copy
end

function toggleOrderBySize()
	if settings.orderBySize == true then
		settings.orderBySize = false
		cacheFileList()
	else
		settings.orderBySize = true
		cacheFileList()
	end
end

function padToWidth(str, width)
	local len = string.len(str)
	if len > width then return str end
	return str .. string.rep(" ", width - len)
end

function generateShaderFileData()
	local shaderDirs, error = utils.readdir(settings.shadersDir, "dirs")
	if error ~= nil then
		msg.error("generateShaderFileData error: " .. error)
		return
	end

	table.sort(shaderDirs)

	settings.shadersGrouped = {}
	local groupNames = {}

	for _, shaderDirName in ipairs(shaderDirs) do
		local shaderFiles, error = utils.readdir(settings.shadersDir .. "/" .. shaderDirName, "files")
		if error == nil then
			table.sort(shaderFiles)
			for _, shaderFileName in ipairs(shaderFiles) do
				if not settings.shadersGrouped[shaderDirName] then
					settings.shadersGrouped[shaderDirName] = {}
					settings.shaderCountsByGroup[shaderDirName] = 0
					table.insert(groupNames, shaderDirName)
				end
				table.insert(settings.shadersGrouped[shaderDirName], shaderFileName)
				settings.shaderCountsByGroup[shaderDirName] = settings.shaderCountsByGroup[shaderDirName] + 1
				settings.shaderIndexByFileName[shaderDirName .. "/" .. shaderFileName] = settings.shaderCountsByGroup[shaderDirName]
			end
		else
			msg.error("Error reading files in " .. shaderDirName)
		end
	end

	for _, groupName in ipairs(groupNames) do
		msg.warn(string.format("        %s %02s", padToWidth(groupName, 20), settings.shaderCountsByGroup[groupName]))
	end
end

function getFilesLinux(dir)
	local flags
	if settings.orderBySize == true then
		flags = ('-1Sp')
	else
		flags = ('-1p' .. (orderByNaturalNumbers and 'v' or ''))
	end
	local args = { 'ls', flags, dir }
	local directoryListing = utils.subprocess({ args = args, cancellable = false })
	return parseFiles(directoryListing, '\n')
end

function parseFiles(res, delimiter)
	if not res.error and res.status == 0 then
		local playableFiles = {}
		for line in res.stdout:gmatch("[^"..delimiter.."]+") do
			local ext = line:match("^.+%.(.+)$")
			if ext and settings.fileTypesToHandle[ext:lower()] then
				table.insert(playableFiles, line)
			end
		end
		return playableFiles, nil
	else
		return nil, res.error
	end
end

function getCurrentDir()
	local pwd = mp.get_property('working-directory')
	local relpath = mp.get_property('path')
	if not pwd or not relpath then return end
	local path = utils.join_path(pwd, relpath)
	local dir = utils.split_path(path)
	return dir
end

function cacheFileList()
	if mp.get_property('filename'):match("^%a%a+:%/%/") then return end

	local dir = getCurrentDir()
	local files, error
	files, error = getFilesLinux(dir)

	if not files then
		msg.error("Subprocess failed: " .. (error or ''))
		return
	end

	msg.warn(#files .. " playable files found")
	if settings.orderBySize == true then
		mp.commandv("show_text", "Refreshed file list (ordered by size)")
	else
		mp.commandv("show_text", "Refreshed file list (ordered by name)")
	end

	settings.fileList = files
	settings.dir = dir
end

function checkFileExists(path)
	local command = {"test", "-e", path}
	local res = utils.subprocess({args = command, cancellable = false})
	return res.status == 0
end

function loadFile(filename)
	local fullpath = utils.join_path(settings.dir, filename)
	local doesFileExist = checkFileExists(fullpath)
	if doesFileExist then
		mp.commandv("show_text", filename)
		mp.commandv("loadfile", fullpath, "replace")
	else
		cacheFileList()
	end
end

function moveToFirstFile()
	local dir = getCurrentDir()
	if not (dir == settings.dir) then
		cacheFileList()
	end
	local firstFile = settings.fileList[1]
	loadFile(firstFile)
end

function getIndexOfCurrentFile(files, currentFileName)
	for index, fileName in ipairs(files) do
		if fileName == currentFileName then
			return index
		end
	end
	return -1
end

function moveToFile(step)
	local dir = getCurrentDir()
	if not (dir == settings.dir) then
		cacheFileList()
	end

	local currentFileName = mp.get_property("filename")
	local nextIndex = 0
	local foundIndex = getIndexOfCurrentFile(settings.fileList, currentFileName)

	if foundIndex ~= -1 then
		clearLoopPoints()
		nextIndex = foundIndex + step
		if nextIndex > #settings.fileList then
			nextIndex = 1
		else
			if nextIndex < 1 then
				nextIndex = #settings.fileList
			end
		end
		local filename = settings.fileList[nextIndex]
		loadFile(filename)
	else
		msg.error("Did not find current file in list")
	end
end

function moveToNextFile()
	moveToFile(1)
end

function moveToPreviousFile()
	moveToFile(-1)
end

function moveBy(num)
	return function()
		moveToFile(num)
	end
end

function moveByRandomAmount()
	local max = #settings.fileList
	if not max or max < 2 then
		mp.commandv("show_text", "max is " .. max)
		return
	end
	local jump = math.random(1, math.floor(max / 10))
	moveToFile(jump)
end





function loadSplashScreen()
	mp.commandv("loadfile", "~/dump/mpv.png", "replace")
end





function toggleShaderPass()
	if settings.whichPass == "pass1" then
		mp.commandv("show_text", "mode: pass2")
		settings.whichPass = "pass2"
	else
		mp.commandv("show_text", "mode: pass1")
		settings.whichPass = "pass1"
	end
end

function setShaderPass1()
	mp.commandv("show_text", "mode: Pass 1")
	settings.whichPass = "pass1"
end

function setShaderPass2()
	mp.commandv("show_text", "mode: Pass 2")
	settings.whichPass = "pass2"
end

function clearShaderPass1()
	settings.pass1 = ""
	applyShaders()
	setShaderPass1()
end

function clearShaderPass2()
	settings.pass2 = ""
	applyShaders()
	setShaderPass2()
end

function isValidShaderName(str)
	return str ~= nil and string.len(str) > 0
end

function removeExtension(fileName)
	return string.gsub(fileName, "%.glsl", "")
end

function getIndexByFileName(fileName)
	local index = settings.shaderIndexByFileName[fileName]
	if type(index) == "number" then
		index = tostring(string.format("%02d", index - 1))
	else
		index = fileName .. "ERROR_BAD_INDEX"
	end
	return index
end

function seekByAbsolutePercent(percentValue)
	mp.commandv("seek", percentValue, "absolute-percent")
end

function executeCommand()
	if string.len(settings.shaderDigits) ~= 2 then
		msg.error("show_text", "executeCommand: shader number is " .. settings.shaderDigits .. "; needs to be two digits")
		return
	end

	if settings.shaderGroup == "seek" then
		local seekPercent = tonumber(settings.shaderDigits)
		if seekPercent ~= 0 then
			mp.commandv("show_text", string.format("%s %s", settings.shaderGroup, settings.shaderDigits))
			seekByAbsolutePercent(seekPercent)
		else
			mp.commandv("show_text", settings.shaderGroup)
		end
		return
	elseif settings.shaderGroup == "equalizer" then
		local presetIndex = tonumber(settings.shaderDigits) + 1
		if presetIndex > #equalizerPresets then
			mp.commandv("show_text", string.format("There are only %d equalizer presets", #equalizerPresets))
		else
			mp.commandv("show_text", string.format("%s %s", settings.shaderGroup, presetIndex))
			mp.commandv("set", "af", equalizerPresets[presetIndex])
		end
		return
	end

	local shaderFile
	local shaderIndex = tonumber(settings.shaderDigits) + 1
	local group = settings.shaderGroup

	if settings.shadersGrouped[group] then
		shaderFile = settings.shadersGrouped[group][shaderIndex]
	else
		msg.error(string.format("settings.shadersGrouped[%s] is %s", group, settings.shadersGrouped[settings.shaderGroup]))
	end

	if shaderFile ~= nil then
		settings[settings.whichPass] = group .. "/" .. shaderFile
		applyShaders()
	else
		local message = string.format("No shader for group %s at index %d", group, shaderIndex - 1)
		mp.commandv("show_text", message)
		msg.error(message)
	end
end

function applyShaders()
	local message = ""
	local SHADERS_DIR = "~/.config/mpv/shaders/"
	local LIST_SEPARATOR_UNIX = ":"
	local LIST_SEPARATOR_WINDOWS = ";"

	if isValidShaderName(settings.pass1) then
		if isValidShaderName(settings.pass2) then
			local index1 = getIndexByFileName(settings.pass1)
			local index2 = getIndexByFileName(settings.pass2)
			message =  string.format("%s [%s] + %s [%s]", removeExtension(settings.pass1), index1, removeExtension(settings.pass2), index2)
			mp.commandv("change-list", "glsl-shaders", "set", SHADERS_DIR .. settings.pass1 .. LIST_SEPARATOR_UNIX .. SHADERS_DIR .. settings.pass2)
		else
			local index = getIndexByFileName(settings.pass1)
			message = string.format("Pass 1: %s [%s]", removeExtension(settings.pass1), index)
			mp.commandv("change-list", "glsl-shaders", "set", SHADERS_DIR .. settings.pass1)
		end
	else
		if isValidShaderName(settings.pass2) then
			local index = getIndexByFileName(settings.pass2)
			message = string.format("Pass 2: %s [%s]", removeExtension(settings.pass2), index)
			mp.commandv("change-list", "glsl-shaders", "set", SHADERS_DIR .. settings.pass2)
		else
			clearShaders()
		end
	end

	if string.len(message) > 0 then
		mp.commandv("show_text", message)
	end
end

function clearShaders()
	mp.commandv("change-list", "glsl-shaders", "clr", "")
	settings.pass1 = ""
	settings.pass2 = ""
	settings.whichPass = "pass2"
	mp.commandv("show_text", "GLSL shaders cleared")
end

function setShaderNumber(num)
	return function()
		if string.len(settings.shaderDigits) == 2 then
			settings.shaderDigits = tostring(num)
			mp.commandv("show_text", string.format("%s %s, awaiting input", settings.shaderGroup, settings.shaderDigits))
		else
			settings.shaderDigits = settings.shaderDigits .. num

			local shaderNumber = tonumber(settings.shaderDigits)
			local maxIndex = getCurrentGroupShaderCount()
			if shaderNumber > maxIndex then
				settings.shaderDigits = tostring(string.format("%02d", maxIndex))
			end

			if string.len(settings.shaderDigits) == 2 then
				executeCommand()
			end
		end
	end
end

function setShaderGroupHandler(groupName)
	return function()
		setShaderGroup(groupName)
	end
end

function setShaderGroup(groupName)
	settings.shaderGroup = groupName
	settings.shaderDigits = "00"
	executeCommand()
end

function getCurrentGroupShaderCount()
	if settings.shaderGroup == "seek" then return 99 end

	local groupShaderCount = settings.shaderCountsByGroup[settings.shaderGroup]

	if type(groupShaderCount) ~= "number" then
		msg.error("getCurrentGroupShaderCount: groupShaderCount is " .. type(groupShaderCount))
		groupShaderCount = 99
	else
		groupShaderCount = groupShaderCount - 1
	end

	return groupShaderCount
end

function nextShader()
	local shaderNumber = math.min(tonumber(settings.shaderDigits) + 1, math.min(99, getCurrentGroupShaderCount()))
	settings.shaderDigits = tostring(string.format("%02d", shaderNumber))
	executeCommand()
end

function prevShader()
	local shaderNumber = math.max(tonumber(settings.shaderDigits) - 1, 0)
	settings.shaderDigits = tostring(string.format("%02d", shaderNumber))
	executeCommand()
end

function saveShaderPreset(presetNumber)
	return function()
		mp.commandv("show_text", "Saved shader preset " .. presetNumber)
		settings.shaderPresets[presetNumber][1] = settings.pass1
		settings.shaderPresets[presetNumber][2] = settings.pass2
	end
end

function loadShaderPreset(presetNumber)
	return function()
		settings.pass1 = settings.shaderPresets[presetNumber][1]
		settings.pass2 = settings.shaderPresets[presetNumber][2]
		applyShaders()
	end
end

function resetShaderPresets()
	settings.shaderPresets = deepCopy(presets01)
	mp.commandv("show_text", "Restored shader presets")
end





function getFirstFile(res, delimiter)
	if not res.error and res.status == 0 then
		return string.match(res.stdout, "[^"..delimiter.."]+"), nil
	else
		return nil, res.error
	end
end

function getLastModifiedFile(dir)
	local flags = ('-1c')
	local args = { 'ls', flags, dir }
	local directoryListing = utils.subprocess({ args = args, cancellable = false })
	return getFirstFile(directoryListing, '\n')
end

function loadLastModifiedShader()
	local file, error
	file, error = getLastModifiedFile(settings.shadersDir)
	if not file then
		msg.error("Subprocess failed: " .. (error or ''))
		return
	end
	mp.commandv("change-list", "glsl-shaders", "set", "~/.config/mpv/shaders/" .. file)
	mp.commandv("show_text", "loaded shader " .. file)
end

function setDevShaderGroup()
	local file, error
	local group
	file, error = getLastModifiedFile(settings.shadersDir)
	if not file then
		msg.error("Subprocess failed: " .. (error or ''))
		return
	end
	group = string.match(file, "[^_]+") .. "_"
	setShaderGroup(group)
	mp.commandv("show_text", "Shader group set to " .. group)
end





function setLoopPointA()
	mp.set_property("ab-loop-a", mp.get_property("time-pos"))
	mp.commandv("show_text", "Point A set")
end

function setLoopPointB()
	mp.set_property("ab-loop-b", mp.get_property("time-pos"))
	mp.commandv("show_text", "Point B set")
end

function clearLoopPoints()
	mp.set_property("ab-loop-a", "no")
	mp.set_property("ab-loop-b", "no")
end





function bindKeys()
	for key, shaderGroup in pairs(shaderGroupsByKey) do
		mp.add_forced_key_binding(key, 'setShaderGroup' .. shaderGroup, setShaderGroupHandler(shaderGroup))
	end

	for i = 0, 9 do
		mp.add_forced_key_binding(tostring(i), 'setShaderNumber' .. i, setShaderNumber(i))
	end

	mp.add_forced_key_binding('HOME', 'moveToFirstFile', moveToFirstFile)
	mp.add_forced_key_binding('END', 'cacheFileList', cacheFileList)
	mp.add_forced_key_binding('PGDWN', 'moveToNextFile', moveToNextFile)
	mp.add_forced_key_binding('PGUP', 'moveToPreviousFile', moveToPreviousFile)
	mp.add_forced_key_binding('Ctrl+PGDWN', 'moveBy10', moveBy(10))
	mp.add_forced_key_binding('Ctrl+PGUP', 'moveBackBy10', moveBy(-10))
	mp.add_forced_key_binding('Ctrl+Shift+PGDWN', 'moveBy50', moveBy(50))
	mp.add_forced_key_binding('Ctrl+Shift+PGUP', 'moveBackBy50', moveBy(-50))
	mp.add_forced_key_binding('Alt+PGDWN', 'moveByRandomAmount', moveByRandomAmount)

	mp.add_forced_key_binding('Shift+F1', 'saveShader1', saveShaderPreset(1))
	mp.add_forced_key_binding('Shift+F2', 'saveShader2', saveShaderPreset(2))
	mp.add_forced_key_binding('Shift+F3', 'saveShader3', saveShaderPreset(3))
	mp.add_forced_key_binding('Shift+F4', 'saveShader4', saveShaderPreset(4))
	mp.add_forced_key_binding('Shift+F5', 'saveShader5', saveShaderPreset(5))
	mp.add_forced_key_binding('Shift+F6', 'saveShader6', saveShaderPreset(6))
	mp.add_forced_key_binding('Shift+F7', 'saveShader7', saveShaderPreset(7))
	mp.add_forced_key_binding('Shift+F8', 'saveShader8', saveShaderPreset(8))
	mp.add_forced_key_binding('Shift+F9', 'saveShader9', saveShaderPreset(9))
	mp.add_forced_key_binding('Shift+F10', 'saveShader10', saveShaderPreset(10))
	mp.add_forced_key_binding('Shift+F11', 'saveShader11', saveShaderPreset(11))
	mp.add_forced_key_binding('Shift+F12', 'saveShader12', saveShaderPreset(12))

	mp.add_forced_key_binding('F1', 'loadShader1', loadShaderPreset(1))
	mp.add_forced_key_binding('F2', 'loadShader2', loadShaderPreset(2))
	mp.add_forced_key_binding('F3', 'loadShader3', loadShaderPreset(3))
	mp.add_forced_key_binding('F4', 'loadShader4', loadShaderPreset(4))
	mp.add_forced_key_binding('F5', 'loadShader5', loadShaderPreset(5))
	mp.add_forced_key_binding('F6', 'loadShader6', loadShaderPreset(6))
	mp.add_forced_key_binding('F7', 'loadShader7', loadShaderPreset(7))
	mp.add_forced_key_binding('F8', 'loadShader8', loadShaderPreset(8))
	mp.add_forced_key_binding('F9', 'loadShader9', loadShaderPreset(9))
	mp.add_forced_key_binding('F10', 'loadShader10', loadShaderPreset(10))
	mp.add_forced_key_binding('F11', 'loadShader11', loadShaderPreset(11))
	mp.add_forced_key_binding('F12', 'loadShader12', loadShaderPreset(12))

	mp.add_forced_key_binding('`', 'clearShaders', clearShaders)
	mp.add_forced_key_binding('Ctrl+w', 'loadSplashScreen', loadSplashScreen)

	mp.add_forced_key_binding(';', 'setShaderPass1', setShaderPass1)
	mp.add_forced_key_binding("'", 'setShaderPass2', setShaderPass2)
	mp.add_forced_key_binding(":", 'clearShaderPass1', clearShaderPass1)
	mp.add_forced_key_binding('"', 'clearShaderPass2', clearShaderPass2)

	mp.add_forced_key_binding("[", 'prevShader', prevShader)
	mp.add_forced_key_binding("]", 'nextShader', nextShader)

	mp.add_forced_key_binding('Ctrl+l', 'loadLastModifiedShader', loadLastModifiedShader)
	mp.add_forced_key_binding('Ctrl+k', 'setDevShaderGroup', setDevShaderGroup)
	mp.add_forced_key_binding('Ctrl+p', 'resetShaderPresets', resetShaderPresets)

	mp.add_forced_key_binding("A", 'setLoopPointA', setLoopPointA)
	mp.add_forced_key_binding("S", 'setLoopPointB', setLoopPointB)

	mp.add_forced_key_binding('Ctrl+o', 'toggleOrderBySize', toggleOrderBySize)
	mp.add_forced_key_binding('Ctrl+u', 'generateShaderFileData', generateShaderFileData)
end





function main()
	generateShaderFileData()
	settings.shaderPresets = deepCopy(presets01)
	bindKeys()
end

main()
