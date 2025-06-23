VERSION = "0.0.1"

local micro = import("micro")
local config = import("micro/config")

local colorSchemes = {
	"gen00",
	"gen01",
	"gen02",
	"gen03",
	"gen04",
	"gen05",
	"gen06",
	"gen07",
	"gen08",
	"gen09",
	"gen10",
	"gen11",
	"gen12",
	"gen13",
	"gen14",
	"gen15",
	"gen16",
	"gen17",
	"gen18",
	"gen19",
	"gen20",
	"gen21",
	"gen22",
	"gen23",
	"gen24",
	"gen25",
	"gen26",
	"gen27",
	"gen28",
	"gen29",
	"gen30",
	"gen31",
	"gen32",
	"gen33",
	"gen34",
	"gen35",
	"gen36",
	"gen37",
	"gen38",
	"gen39",
	"gen40",
	"gen41",
	"gen42",
	"gen43",
	"gen44",
	"gen45",
	"gen46",
	"gen47",
	"gen48",
	"gen49",
	"gen50",
	"gen51",
	"gen52",
	"gen53",
	"gen54",
	"gen55",
	"gen56",
	"gen57",
	"gen58",
	"gen59",
	"gen60",
	"gen61",
	"gen62",
	"gen63",
	"gen64",
	"gen65",
	"gen66",
	"gen67",
	"gen68",
	"gen69",
	"gen70",
	"gen71",
	"gen72",
	"gen73",
	"gen74",
	"gen75",
	"gen76",
	"gen77",
	"gen78",
	"gen79",
	"gen80",
	"gen81",
	"gen82",
	"gen83",
	"gen84",
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

function firstColorScheme()
	local firstColorScheme = colorSchemes[1]
	micro.InfoBar():Message("color scheme set to ", firstColorScheme)
	config.SetGlobalOption("colorscheme", firstColorScheme)
end

function init()
	config.MakeCommand("firstcolorscheme", firstColorScheme, config.NoComplete)
	config.MakeCommand("nextcolorscheme", nextColorScheme, config.NoComplete)
	config.MakeCommand("previouscolorscheme", previousColorScheme, config.NoComplete)
end
