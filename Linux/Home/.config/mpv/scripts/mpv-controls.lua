local utils = require 'mp.utils'
local msg = require 'mp.msg'

os.setlocale("")

local settings = {
	filetypes = { 'jpg', 'jpeg', 'png', 'gif', 'webp', 'bmp', 'mp3', 'wav', 'ogm', 'flac', 'm4a', 'wma', 'ogg', 'opus', 'mkv', 'avi', 'mp4', 'ogv', 'webm', 'rmvb', 'flv', 'wmv', 'mpeg', 'mpg', 'm4v', '3gp', 'm2ts', 'mov', 'psd' },
	fileList = {},
	dir = "",
	--order by natural (version) numbers, thus behaving case-insensitively and treating multi-digit numbers atomically
	--e.x.: true will result in the following order:   09A 9A  09a 9a  10A 10a
	--      while false will result in:                09a 09A 10a 10A 9a  9A
	orderByNaturalNumbers = false,

	shaderGroup = "Blue1_",
	shaderNumber = 1,
	pass1 = "",
	pass2 = "",
	whichPass = "pass2",
	shaderPresets = {
		{ "Brightness2_03", "BlendCool01" },
		{ "Curve07", "BlendCool01" },
		{ "Brightness2_03", "BlendCool04" },
		{ "Curve07", "BlendCool04" },
		{ "", "SaturateSelective01" },
		{ "", "SaturateSelective02" },
		{ "", "SaturateSelective09" },
		{ "", "SaturateSelective10" },
		{ "Brightness2_02", "BlendWarm10" },
		{ "Curve07", "BlendWarm01" },
		{ "Curve07", "BlendWarm02" },
		{ "Curve07", "BlendWarm10" },
	},

	eqIndex = 1,
	eqFrequencies = {128, 250, 500, 1000, 2000, 4000, 6000, 8000, 12000, 16000},
	eqWidths = {1, 1, 1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5},
	eqGains = {0, 0, -9, -12, -12, -12, -12, -18, -18, -21}
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
		-- table.sort(playableFiles)
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

	settings.fileList = files
	settings.dir = dir
end

function loadFile(filename)
	mp.commandv("show_text", filename)
	mp.commandv("loadfile", utils.join_path(settings.dir, filename), "replace")
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
	local currentFileNameLower = string.lower(currentFileName)
	local found = false
	while (min < max) do
		index = math.floor((min + max) / 2)
		local value = string.lower(files[index])
		if (currentFileNameLower == value) then
			found = true
			return index
		end
		if (currentFileNameLower < value) then
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
		loadFile(settings.fileList[nextIndex])
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
	local shaderName = ""
	if (settings.shaderNumber == 0) then
		shaderName = settings.shaderGroup .. "10"
	else
		shaderName = settings.shaderGroup .. "0" .. settings.shaderNumber
	end
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

function setShaderGroup(groupName)
	return function()
		settings.shaderGroup = groupName
		settings.shaderNumber = 1
		setShaderFileAndPass()
	end
end

function setShaderNumber(num)
	return function()
		settings.shaderNumber = num
		setShaderFileAndPass()
	end
end

function saveShaderPreset(presetNumber)
	return function()
		mp.commandv("show_text", "Saved quick shader" .. presetNumber)
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


-- ____________________________________________________________________________________________________

function applyEqualizerSettings()
	local eqString = ""
	for i = 1, 10 do
		eqString = eqString .. "equalizer=f=" .. settings.eqFrequencies[i] .. ":t=o:w=" .. settings.eqWidths[i] .. ":g=" .. settings.eqGains[i]
		if i ~= 10 then
			eqString = eqString .. ","
		end
	end
	mp.command(string.format("af set \"%s\"", eqString))
end

function prevFrequencyBand()
	settings.eqIndex = math.max(settings.eqIndex - 1, 1);
	mp.commandv("show_text", settings.eqFrequencies[settings.eqIndex])
end

function nextFrequencyBand()
	settings.eqIndex = math.min(settings.eqIndex + 1, 10);
	mp.commandv("show_text", settings.eqFrequencies[settings.eqIndex])
end

function increaseGain()
	settings.eqGains[settings.eqIndex] = settings.eqGains[settings.eqIndex] + 3
	applyEqualizerSettings()
end

function decreaseGain()
	settings.eqGains[settings.eqIndex] = settings.eqGains[settings.eqIndex] - 3
	applyEqualizerSettings()
end


-- ____________________________________________________________________________________________________

mp.add_forced_key_binding('KP8', 'moveToFirstFile', moveToFirstFile)
mp.add_forced_key_binding('PGDWN', 'moveToNextFile', moveToNextFile)
mp.add_forced_key_binding('PGUP', 'moveToPreviousFile', moveToPreviousFile)
mp.add_forced_key_binding('Ctrl+PGDWN', 'moveBy10', moveBy(10))
mp.add_forced_key_binding('Ctrl+PGUP', 'moveBackBy10', moveBy(-10))
mp.add_forced_key_binding('Ctrl+Shift+PGDWN', 'moveBy50', moveBy(50))
mp.add_forced_key_binding('Ctrl+Shift+PGUP', 'moveBackBy50', moveBy(-50))

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

mp.add_forced_key_binding('q', 'set_shaders_Blue1', setShaderGroup('Blue1_'))
mp.add_forced_key_binding('w', 'set_shaders_Blue2', setShaderGroup('Blue2_'))
mp.add_forced_key_binding('e', 'set_shaders_Blue3', setShaderGroup('Blue3_'))
mp.add_forced_key_binding('r', 'set_shaders_Blue4', setShaderGroup('Blue4_'))
mp.add_forced_key_binding('t', 'set_shaders_Tint', setShaderGroup('Tint'))
mp.add_forced_key_binding('y', 'set_shaders_MonotoneBlue', setShaderGroup('MonotoneBlue'))
mp.add_forced_key_binding('u', 'set_shaders_LightTint', setShaderGroup('LightTint'))
mp.add_forced_key_binding('i', 'set_shaders_Invert', setShaderGroup('Invert'))
mp.add_forced_key_binding('o', 'set_shaders_ChannelMixer', setShaderGroup('ChannelMixer'))
mp.add_forced_key_binding('p', 'set_shaders_ColorRamp', setShaderGroup('ColorRamp'))
mp.add_forced_key_binding('a', 'set_shaders_Brightness', setShaderGroup('Brightness'))
mp.add_forced_key_binding('s', 'set_shaders_Brightness2', setShaderGroup('Brightness2_'))
mp.add_forced_key_binding('d', 'set_shaders_Saturation1', setShaderGroup('Saturation1_'))
mp.add_forced_key_binding('f', 'set_shaders_Saturation2', setShaderGroup('Saturation2_'))
mp.add_forced_key_binding('g', 'set_shaders_Grayscale', setShaderGroup('Grayscale'))
mp.add_forced_key_binding('h', 'set_shaders_BlendCool', setShaderGroup('BlendCool'))
mp.add_forced_key_binding('j', 'set_shaders_BlendWarm', setShaderGroup('BlendWarm'))
mp.add_forced_key_binding('k', 'set_shaders_Curve', setShaderGroup('Curve'))
mp.add_forced_key_binding('z', 'set_shaders_Test1', setShaderGroup('Test1_'))
mp.add_forced_key_binding('x', 'set_shaders_Test2', setShaderGroup('Test2_'))
mp.add_forced_key_binding('Shift+x', 'set_shaders_ComplexBlend', setShaderGroup('ComplexBlend'))
mp.add_forced_key_binding('c', 'set_shaders_Test3', setShaderGroup('Test3_'))
mp.add_forced_key_binding('Shift+c', 'set_shaders_SaturateSelective', setShaderGroup('SaturateSelective'))
mp.add_forced_key_binding('Shift+z', 'set_shaders_Test4', setShaderGroup('Test4_'))
mp.add_forced_key_binding('v', 'set_shaders_OrangeBlue', setShaderGroup('OrangeBlue'))
mp.add_forced_key_binding('b', 'set_shaders_MonotoneSepia', setShaderGroup('MonotoneSepia'))
mp.add_forced_key_binding('n', 'set_shaders_MonotoneRed', setShaderGroup('MonotoneRed'))
mp.add_forced_key_binding('m', 'set_shaders_Red', setShaderGroup('Red'))

mp.add_forced_key_binding('=', 'cacheFileList', cacheFileList)

mp.add_forced_key_binding('1', 'set_shader_number_1', setShaderNumber(1))
mp.add_forced_key_binding('2', 'set_shader_number_2', setShaderNumber(2))
mp.add_forced_key_binding('3', 'set_shader_number_3', setShaderNumber(3))
mp.add_forced_key_binding('4', 'set_shader_number_4', setShaderNumber(4))
mp.add_forced_key_binding('5', 'set_shader_number_5', setShaderNumber(5))
mp.add_forced_key_binding('6', 'set_shader_number_6', setShaderNumber(6))
mp.add_forced_key_binding('7', 'set_shader_number_7', setShaderNumber(7))
mp.add_forced_key_binding('8', 'set_shader_number_8', setShaderNumber(8))
mp.add_forced_key_binding('9', 'set_shader_number_9', setShaderNumber(9))
mp.add_forced_key_binding('0', 'set_shader_number_0', setShaderNumber(0))

mp.add_forced_key_binding(';', 'setShaderPass1', setShaderPass1)
mp.add_forced_key_binding("'", 'setShaderPass2', setShaderPass2)
mp.add_forced_key_binding(":", 'clearShaderPass1', clearShaderPass1)
mp.add_forced_key_binding('"', 'clearShaderPass2', clearShaderPass2)

mp.add_forced_key_binding('KP7', 'decreaseGain', decreaseGain)
mp.add_forced_key_binding('KP9', 'increaseGain', increaseGain)
mp.add_forced_key_binding('[', 'prevFrequencyBand', prevFrequencyBand)
mp.add_forced_key_binding(']', 'nextFrequencyBand', nextFrequencyBand)

mp.add_forced_key_binding('Ctrl+l', 'loadLastModifiedShader', loadLastModifiedShader)
