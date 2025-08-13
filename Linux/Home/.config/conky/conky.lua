function clamp(value, min, max)
	if value < min then return min
	elseif value > max then return max
	else return value
	end
end

function modifiedLog(intValue)
	if intValue == 0 then return 0
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

	function conky_gpuUtilization()
		local gpuUtilStr = conky_parse('${nvidia gpuutil}')
		local gpuUtilInt = tonumber( string.match(gpuUtilStr, "[%d%.]+") )
		return gpuUtilInt
	end

	function conky_gpuUtilizationBoolean()
		local gpuUtilStr = conky_parse('${nvidia gpuutil}')
		local gpuUtilInt = tonumber( string.match(gpuUtilStr, "[%d%.]+") )
		return gpuUtilInt > 0 and 1 or 0
	end

	function conky_gpuMemUsed()
		local gpuMemUsageStr = conky_parse('${nvidia memused}')
		local gpuMemUsageInt = tonumber( string.match(gpuMemUsageStr, "%d+") )
		return gpuMemUsageInt
	end

	function conky_gpuFrequency()
		local gpuFreqStr = conky_parse('${nvidia gpufreqcur}')
		local gpuFreqInt = tonumber( string.match(gpuFreqStr, "%d+") )
		return gpuFreqInt
	end

	function conky_gpuTemp()
		local gpuTempStr = conky_parse('${nvidia temp}')
		local gpuTempInt = tonumber( string.match(gpuTempStr, "%d+") )
		return clamp(gpuTempInt - 30, 0, 200)
	end

	function conky_gpuPowerDraw()
		local str = conky_parse('${exec nvidia-smi --query-gpu=power.draw --format=csv,noheader,nounits }')
		return tonumber(str)
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

