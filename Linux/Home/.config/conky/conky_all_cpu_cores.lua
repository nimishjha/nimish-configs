	-- function conky_cpuUsageTotal()
	-- 	local cpuUsageTotal = 0
	-- 	for i = 1, 20 do
	-- 		local queryString = string.format("${cpu cpu%d}", i)
	-- 		local cpuUsageStr = conky_parse(queryString)
	-- 		local cpuUsageInt = tonumber( string.match(cpuUsageStr, "%d+") )
	-- 		cpuUsageTotal = cpuUsageTotal + cpuUsageInt
	-- 	end
	-- 	return cpuUsageTotal * 0.05
	-- end


function clamp(value, min, max)
	if value < min then return min
	elseif value > max then return max
	else return value
	end
end

function modifiedLog(intValue)
	if intValue == 0 then return 0
	-- else return clamp(math.floor(math.log(intValue, 10)) - 1, 1, 10)
	else return clamp(math.log(intValue, 10) - 1, 1, 10)
	end
end

do
	function conky_cpuUsageMax()
		local cpuUsageMax = 0
		for i = 1, 20 do
			local queryString = string.format("${cpu cpu%d}", i)
			local cpuUsageStr = conky_parse(queryString)
			local cpuUsageInt = tonumber( string.match(cpuUsageStr, "%d+") )
			if cpuUsageInt > cpuUsageMax then cpuUsageMax = cpuUsageInt end
		end
		return cpuUsageMax
	end

	function conky_cpuFreqMax()
		local cpuFreqMax = 0
		for i = 1, 20 do
			local queryString = string.format("${freq cpu%d}", i)
			local cpuFreqStr = conky_parse(queryString)
			local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") )
			if cpuFreqInt > cpuFreqMax then cpuFreqMax = cpuFreqInt end
		end
		return cpuFreqMax
	end

	function conky_cpuFrequency()
		local cpuFreqStr = conky_parse('${freq}')
		local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") )
		return cpuFreqInt
	end

	 function conky_cpuFrequency1()  local cpuFreqStr = conky_parse('${freq 1}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency2()  local cpuFreqStr = conky_parse('${freq 2}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency3()  local cpuFreqStr = conky_parse('${freq 3}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency4()  local cpuFreqStr = conky_parse('${freq 4}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency5()  local cpuFreqStr = conky_parse('${freq 5}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency6()  local cpuFreqStr = conky_parse('${freq 6}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency7()  local cpuFreqStr = conky_parse('${freq 7}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency8()  local cpuFreqStr = conky_parse('${freq 8}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency9()  local cpuFreqStr = conky_parse('${freq 9}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency10() local cpuFreqStr = conky_parse('${freq 10}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency11() local cpuFreqStr = conky_parse('${freq 11}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency12() local cpuFreqStr = conky_parse('${freq 12}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency13() local cpuFreqStr = conky_parse('${freq 13}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency14() local cpuFreqStr = conky_parse('${freq 14}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency15() local cpuFreqStr = conky_parse('${freq 15}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency16() local cpuFreqStr = conky_parse('${freq 16}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency17() local cpuFreqStr = conky_parse('${freq 17}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency18() local cpuFreqStr = conky_parse('${freq 18}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency19() local cpuFreqStr = conky_parse('${freq 19}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end
	 function conky_cpuFrequency20() local cpuFreqStr = conky_parse('${freq 20}'); local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") ); return cpuFreqInt; end

	function conky_netInLogarithmic()
		local netInStr = conky_parse('${to_bytes ${downspeed enp6s0}}')
		local netInInt = tonumber( string.match(netInStr, "%d+") )
		return modifiedLog(netInInt)
	end

	function conky_netOutLogarithmic()
		local netOutStr = conky_parse('${to_bytes ${upspeed enp6s0}}')
		local netOutInt = tonumber( string.match(netOutStr, "%d+") )
		return modifiedLog(netOutInt)
	end

	function conky_gpuFrequency()
		local gpuFreqStr = conky_parse('${nvidia gpufreqcur}')
		local gpuFreqInt = tonumber( string.match(gpuFreqStr, "%d+") )
		return gpuFreqInt
	end

	function conky_gpuMemUsed()
		local gpuMemUsageStr = conky_parse('${nvidia memused}')
		local gpuMemUsageInt = tonumber( string.match(gpuMemUsageStr, "%d+") )
		return gpuMemUsageInt
	end

	function conky_gpuUtilization()
		local gpuUtilStr = conky_parse('${nvidia gpuutil}')
		local gpuUtilInt = tonumber( string.match(gpuUtilStr, "%d+") )
		return gpuUtilInt
	end

	function conky_gpuTemp()
		local gpuTempStr = conky_parse('${nvidia temp}')
		local gpuTempInt = tonumber( string.match(gpuTempStr, "%d+") )
		return gpuTempInt - 30
	end

	function conky_gpuPowerDraw()
		local str = conky_parse('${exec nvidia-smi --query-gpu=power.draw --format=csv,noheader }')
		local intVal = tonumber( string.match(str, "%d+") )
		return intVal
	end

	function conky_diskIoReadLogarithmic()
		local diskIoReadStr = conky_parse('${to_bytes ${diskio_read}}')
		return modifiedLog(tonumber(string.match(diskIoReadStr, "%d+")))
	end

	function conky_diskIoWriteLogarithmic()
		local diskIoWriteStr = conky_parse('${to_bytes ${diskio_write}}')
		return modifiedLog(tonumber(string.match(diskIoWriteStr, "%d+")))
	end

	function conky_diskIoReadLinear()
		local diskIoReadStr = conky_parse('${to_bytes ${diskio_read}}')
		return tonumber(string.match(diskIoReadStr, "%d+"))
	end

	function conky_diskIoWriteLinear()
		local diskIoWriteStr = conky_parse('${to_bytes ${diskio_write}}')
		return tonumber(string.match(diskIoWriteStr, "%d+"))
	end

end

