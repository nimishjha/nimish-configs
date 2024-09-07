local utils = require 'mp.utils'
local msg = require 'mp.msg'

local settings = {
	eqIndex = 1,
	eqFrequencies = {500, 1000, 2000, 4000, 6000, 8000, 12000, 16000},
	eqWidths = {1, 1, 1, 1, 0.5, 0.5, 0.5, 0.5},
	eqGains = {-9, -12, -12, -12, -12, -18, -18, -21}
}

function applyEqualizerSettings()
	local eqString = ""
	for i = 1, 8 do
		eqString = eqString .. "equalizer=f=" .. settings.eqFrequencies[i] .. ":t=o:w=" .. settings.eqWidths[i] .. ":g=" .. settings.eqGains[i]
		if i ~= 8 then
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
	settings.eqIndex = math.min(settings.eqIndex + 1, 8);
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

mp.add_forced_key_binding('KP7', 'decreaseGain', decreaseGain)
mp.add_forced_key_binding('KP9', 'increaseGain', increaseGain)
mp.add_forced_key_binding('[', 'prevFrequencyBand', prevFrequencyBand)
mp.add_forced_key_binding(']', 'nextFrequencyBand', nextFrequencyBand)
