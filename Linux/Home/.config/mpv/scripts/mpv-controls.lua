local utils = require 'mp.utils'
local msg = require 'mp.msg'
local presets01 = {
	{ "Curve_02", "Dim_02" },
	{ "Curve_15", "BlueNew_00" },
	{ "Curve_16", "BlueNew_00" },
	{ "Dim_02", "BlueNew_00" },
	{ "Curve_14", "RedBlue_00" },
	{ "Curve_15", "RedBlue_00" },
	{ "Curve_16", "RedBlue_00" },
	{ "Curve_17", "RedBlue_00" },
	{ "Curve_14", "ChannelMixer_00" },
	{ "Curve_15", "RedBlue_30" },
	{ "Curve_16", "MonotoneRed_01" },
	{ "Curve_14", "ChannelMixer_80" },
}

os.setlocale("")

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

local settings = {
	filetypes = { 'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'mp3', 'wav', 'ogm', 'flac', 'm4a', 'wma', 'ogg', 'opus', 'mkv', 'avi', 'mp4', 'ogv', 'webm', 'rmvb', 'flv', 'wmv', 'mpeg', 'mpg', 'm4v', '3gp', 'm2ts', 'mov', 'psd', 'aac' },
	fileList = {},
	dir = "",
	orderByNaturalNumbers = false,

	shaderGroup = "BlueNew_",
	shaderNumber = "00",
	pass1 = "",
	pass2 = "",
	whichPass = "pass2",
	shaderPresets = deepCopy(presets01),
}

local fileTypesToHandle = {}
for _, ext in ipairs(settings.filetypes) do
	fileTypesToHandle[ext] = true
end

function getFilesLinux(dir)
	local flags = ('-1p' .. (orderByNaturalNumbers and 'v' or ''))
	local args = { 'ls', flags, dir }
	local directoryListing = utils.subprocess({ args = args, cancellable = false })
	return parseFiles(directoryListing, '\n')
end

function parseFiles(res, delimiter)
	if not res.error and res.status == 0 then
		local playableFiles = {}
		for line in res.stdout:gmatch("[^"..delimiter.."]+") do
			local ext = line:match("^.+%.(.+)$")
			if ext and fileTypesToHandle[ext:lower()] then
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
	mp.commandv("show_text", "Refreshed file list")

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
	if (doesFileExist) then
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
	local min = 1
	local max = #files
	local index
	local found = false
	while (min < max) do
		index = math.floor((min + max) / 2)
		local value = files[index]
		if (currentFileName == value) then
			found = true
			return index
		end
		if (currentFileName < value) then
			max = index - 1
		else
			min = index + 1
		end
	end

	if (min == max) then
		return min
	end

	if not (found) then
		msg.warn("File not found using binary search: ", currentFileName)
		for index, fileName in ipairs(files) do
			if (fileName == currentFileName) then
				return index
			end
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

	if (foundIndex ~= -1) then
		nextIndex = foundIndex + step
		if (nextIndex > #settings.fileList) then
			nextIndex = 1
		else
			if (nextIndex < 1) then
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
	if (not max or max < 2) then
		mp.commandv("show_text", "max is " .. max)
		return
	end
	local jump = math.random(1, math.floor(max / 10))
	moveToFile(jump)
end

-- ____________________________________________________________________________________________________

function loadSplashScreen()
	mp.commandv("loadfile", "/home/terminator/Pictures/plainGreyBackground.png", "replace")
end

-- ____________________________________________________________________________________________________

function toggleShaderPass()
	if (settings.whichPass == "pass1") then
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

function setShaderFileAndPass()
	if(string.len(settings.shaderNumber) ~= 2) then
		mp.commandv("show_text", "Shader number is" .. settings.shaderNumber .. "; needs to be two digits")
		return
	end
	local shaderName = settings.shaderGroup .. settings.shaderNumber
	if (settings.whichPass == "pass1") then
		settings.pass1 = shaderName
	else
		settings.pass2 = shaderName
	end
	applyShaders()
end

function isValidShaderName(str)
	return str ~= nil and string.len(str) > 0
end

function applyShaders()
	local message = ""
	if(isValidShaderName(settings.pass1)) then
		if (isValidShaderName(settings.pass2)) then
			message = settings.pass1 .. " + " .. settings.pass2
			mp.commandv("change-list", "glsl-shaders", "set", "~/.config/mpv/shaders/" .. settings.pass1 .. ".glsl")
			mp.commandv("change-list", "glsl-shaders", "append", "~/.config/mpv/shaders/" .. settings.pass2 .. ".glsl")
		else
			message = "Pass 1: " .. settings.pass1
			mp.commandv("change-list", "glsl-shaders", "set", "~/.config/mpv/shaders/" .. settings.pass1 .. ".glsl")
		end
	else
		if (isValidShaderName(settings.pass2)) then
			message = "Pass 2:" .. settings.pass2
			mp.commandv("change-list", "glsl-shaders", "set", "~/.config/mpv/shaders/" .. settings.pass2 .. ".glsl")
		else
			clearShaders()
		end
	end
	if(string.len(message) > 0) then
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

function setShaderGroupHandler(groupName)
	return function()
		setShaderGroup(groupName)
	end
end

function setShaderGroup(groupName)
	settings.shaderGroup = groupName
	settings.shaderNumber = "00"
	setShaderFileAndPass()
end

function setShaderNumber(num)
	return function()
		if(string.len(settings.shaderNumber) == 2) then
			settings.shaderNumber = tostring(num)
			mp.commandv("show_text", "shader number is " .. settings.shaderNumber)
		else
			settings.shaderNumber = settings.shaderNumber .. num
			setShaderFileAndPass()
		end
	end
end

function nextShader()
	local shaderNumber = tonumber(settings.shaderNumber) + 1
	if shaderNumber > 99 then
		shaderNumber = 99
	end
	settings.shaderNumber = tostring(shaderNumber)
	if(string.len(settings.shaderNumber) < 2) then
		settings.shaderNumber = "0" .. settings.shaderNumber
	end
	setShaderFileAndPass()
end

function prevShader()
	local shaderNumber = tonumber(settings.shaderNumber) - 1
	if shaderNumber < 0 then
		shaderNumber = 0
	end
	settings.shaderNumber = tostring(shaderNumber)
	if(string.len(settings.shaderNumber) < 2) then
		settings.shaderNumber = "0" .. settings.shaderNumber
	end
	setShaderFileAndPass()
end

function saveShaderPreset(presetNumber)
	return function()
		mp.commandv("show_text", "Saved quick shader " .. presetNumber)
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

-- ____________________________________________________________________________________________________

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
	local dir = mp.command_native({"expand-path", "~~home/"}) .. "/shaders"
	local file, error
	file, error = getLastModifiedFile(dir)
	if not file then
		msg.error("Subprocess failed: " .. (error or ''))
		return
	end
	mp.commandv("change-list", "glsl-shaders", "set", "~/.config/mpv/shaders/" .. file)
	mp.commandv("show_text", "loaded shader " .. file)
end

function setDevShaderGroup()
	local dir = mp.command_native({"expand-path", "~~home/"}) .. "/shaders"
	local file, error
	local group
	file, error = getLastModifiedFile(dir)
	if not file then
		msg.error("Subprocess failed: " .. (error or ''))
		return
	end
	group = string.match(file, "[^_]+") .. "_"
	setShaderGroup(group)
	mp.commandv("show_text", "Shader group set to " .. group)
end

-- ____________________________________________________________________________________________________

function setLoopPointA()
	mp.set_property("ab-loop-a", mp.get_property("time-pos"))
	mp.commandv("show_text", "Point A set")
end

function setLoopPointB()
	mp.set_property("ab-loop-b", mp.get_property("time-pos"))
	mp.commandv("show_text", "Point B set")
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

mp.add_forced_key_binding('q', 'setShaderGroupBlueNew', setShaderGroupHandler('BlueNew_'))
mp.add_forced_key_binding('w', 'setShaderGroupPsychedelic', setShaderGroupHandler('Psychedelic_'))
mp.add_forced_key_binding('e', 'setShaderGroupRedBlue', setShaderGroupHandler('RedBlue_'))
mp.add_forced_key_binding('r', 'setShaderGroupRed', setShaderGroupHandler('Red_'))
mp.add_forced_key_binding('t', 'setShaderGroupTint', setShaderGroupHandler('Tint_'))
mp.add_forced_key_binding('y', 'setShaderGroupGreen', setShaderGroupHandler('Green_'))
mp.add_forced_key_binding('u', 'setShaderGroupLightTint', setShaderGroupHandler('LightTint_'))
mp.add_forced_key_binding('i', 'setShaderGroupInvert', setShaderGroupHandler('Invert'))
mp.add_forced_key_binding('o', 'setShaderGroupChannelMixer', setShaderGroupHandler('ChannelMixer_'))
mp.add_forced_key_binding('p', 'setShaderGroupColorRamp', setShaderGroupHandler('ColorRamp_'))
mp.add_forced_key_binding('a', 'setShaderGroupBright', setShaderGroupHandler('Bright_'))
mp.add_forced_key_binding('s', 'setShaderGroupDim', setShaderGroupHandler('Dim_'))
mp.add_forced_key_binding('d', 'setShaderGroupSaturate', setShaderGroupHandler('Saturate_'))
mp.add_forced_key_binding('f', 'setShaderGroupSaturateSelective', setShaderGroupHandler('SaturateSelective_'))
mp.add_forced_key_binding('g', 'setShaderGroupGrayscale', setShaderGroupHandler('Grayscale_'))
mp.add_forced_key_binding('h', 'setShaderGroupBlendCool', setShaderGroupHandler('BlendCool_'))
mp.add_forced_key_binding('j', 'setShaderGroupBlendWarm', setShaderGroupHandler('BlendWarm_'))
mp.add_forced_key_binding('k', 'setShaderGroupCurve', setShaderGroupHandler('Curve_'))
mp.add_forced_key_binding('z', 'setShaderGroupZ', setShaderGroupHandler('z_'))
mp.add_forced_key_binding('x', 'setShaderGroupx', setShaderGroupHandler('x_'))
mp.add_forced_key_binding('c', 'setShaderGroupc', setShaderGroupHandler('c_'))
mp.add_forced_key_binding('v', 'setShaderGroupOrangeBlue', setShaderGroupHandler('OrangeBlue_'))
mp.add_forced_key_binding('b', 'setShaderGroupMonotoneSepia', setShaderGroupHandler('MonotoneSepia_'))
mp.add_forced_key_binding('n', 'setShaderGroupMonotoneRed', setShaderGroupHandler('MonotoneRed_'))
mp.add_forced_key_binding('m', 'setShaderGroupMonotoneBlue', setShaderGroupHandler('MonotoneBlue_'))

mp.add_forced_key_binding('1', 'setShaderNumber1', setShaderNumber(1))
mp.add_forced_key_binding('2', 'setShaderNumber2', setShaderNumber(2))
mp.add_forced_key_binding('3', 'setShaderNumber3', setShaderNumber(3))
mp.add_forced_key_binding('4', 'setShaderNumber4', setShaderNumber(4))
mp.add_forced_key_binding('5', 'setShaderNumber5', setShaderNumber(5))
mp.add_forced_key_binding('6', 'setShaderNumber6', setShaderNumber(6))
mp.add_forced_key_binding('7', 'setShaderNumber7', setShaderNumber(7))
mp.add_forced_key_binding('8', 'setShaderNumber8', setShaderNumber(8))
mp.add_forced_key_binding('9', 'setShaderNumber9', setShaderNumber(9))
mp.add_forced_key_binding('0', 'setShaderNumber0', setShaderNumber(0))

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
