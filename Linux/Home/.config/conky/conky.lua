do

	function conky_netInLinear()
		local netInStr = conky_parse('${to_bytes ${downspeed enp6s0}}')
		local netInInt = tonumber( string.match(netInStr, "%d+") )
		local netInLinear = (netInInt / 1000000)
		return netInLinear
	end

	function conky_netOutLinear()
		local netOutStr = conky_parse('${to_bytes ${upspeed enp6s0}}')
		local netOutInt = tonumber( string.match(netOutStr, "%d+") )
		local netOutLinear = (netOutInt / 100000)
		return netOutLinear
	end

	function conky_netInNonLinear()
		local netInStr = conky_parse('${to_bytes ${downspeed enp6s0}}')
		local netInInt = tonumber( string.match(netInStr, "%d+") )
		local netInNonLinear = (netInInt / 20000000) ^ 0.2
		return netInNonLinear
	end

	function conky_netOutNonLinear()
		local netOutStr = conky_parse('${to_bytes ${upspeed enp6s0}}')
		local netOutInt = tonumber( string.match(netOutStr, "%d+") )
		local netOutNonLinear = (netOutInt / 2000000) ^ 0.2
		return netOutNonLinear
	end

	function conky_gpuFrequency()
		local gpuFreqStr = conky_parse('${nvidia gpufreqcur}')
		local gpuFreqInt = tonumber( string.match(gpuFreqStr, "%d+") )
		return gpuFreqInt
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
		local int = tonumber( string.match(str, "%d+") )
		return int
	end

	function conky_cpuFrequency()
		local cpuFreqStr = conky_parse('${freq}')
		local cpuFreqInt = tonumber( string.match(cpuFreqStr, "%d+") )
		return cpuFreqInt
	end

	function conky_diskIoReadNonLinear()
		local diskIoReadStr = conky_parse('${to_bytes ${diskio_read}}')
		local diskIoReadInt = tonumber( string.match(diskIoReadStr, "%d+") )
		local diskIoReadNonLinear = (diskIoReadInt / 20000000) ^ 0.2
		return diskIoReadNonLinear
	end

	function conky_diskIoWriteNonLinear()
		local diskIoWriteStr = conky_parse('${to_bytes ${diskio_write}}')
		local diskIoWriteInt = tonumber( string.match(diskIoWriteStr, "%d+") )
		local diskIoWriteNonLinear = (diskIoWriteInt / 20000000) ^ 0.2
		return diskIoWriteNonLinear
	end

end

