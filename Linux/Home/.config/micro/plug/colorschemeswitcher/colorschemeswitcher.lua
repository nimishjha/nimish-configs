VERSION = "0.0.1"

local micro = import("micro")
local config = import("micro/config")

local colorSchemes = {
	"blackandgold",
	"blue01",
	"blue02",
	"blue03",
	"blue04",
	"blue05",
	"blue06",
	"bluegreen01",
	"bluegreen02",
	"bluegreen03",
	"bluegreen04",
	"bluegreen05",
	"bluegreen06",
	"bluegreen07",
	"gray01",
	"green01",
	"green02",
	"green03",
	"green04",
	"purple01",
	"purple02",
	"purple03",
	"purple04",
	"purple05",
	"red01",
	"red02",
	"red03",
	"taupe01"
}


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

function init()
	config.MakeCommand("nextcolorscheme", nextColorScheme, config.NoComplete)
	config.MakeCommand("previouscolorscheme", previousColorScheme, config.NoComplete)
end
