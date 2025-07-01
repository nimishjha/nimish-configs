VERSION = "0.0.1"

local micro = import("micro")
local config = import("micro/config")

local DIR = "~/.config/micro/colorschemes"

function getThemeFiles(dir)
	local f = io.popen("ls -1p " .. dir, "r")
	local dir = {}
	for entry in f:lines() do
		dir[#dir + 1] = entry:gsub("\.micro", "")
	end

	return dir
end

local colorSchemes = getThemeFiles(DIR)

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

function nextColorScheme()
	local colorScheme = config.GetGlobalOption("colorscheme")
	local nextColorScheme = getNextString(colorSchemes, colorScheme)
	micro.InfoBar():Message("color scheme set to ", nextColorScheme)
	config.SetGlobalOption("colorscheme", nextColorScheme)
end

function previousColorScheme()
	local colorScheme = config.GetGlobalOption("colorscheme")
	local previousColorScheme = getPreviousString(colorSchemes, colorScheme)
	micro.InfoBar():Message("color scheme set to ", previousColorScheme)
	config.SetGlobalOption("colorscheme", previousColorScheme)
end

function firstColorScheme()
	local firstColorScheme = colorSchemes[1]
	micro.InfoBar():Message("color scheme set to ", firstColorScheme)
	config.SetGlobalOption("colorscheme", firstColorScheme)
end

function init()
	-- micro.InfoBar():Message("colorSchemeSwitcher: " .. #colorSchemes .. " themes")
	config.MakeCommand("firstcolorscheme", firstColorScheme, config.NoComplete)
	config.MakeCommand("nextcolorscheme", nextColorScheme, config.NoComplete)
	config.MakeCommand("previouscolorscheme", previousColorScheme, config.NoComplete)
end
