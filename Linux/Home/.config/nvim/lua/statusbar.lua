local M = {}

function getHighlightGroup(mode)
	local highlightGroupMap = {
		n = "EndOfBuffer",
		i = "DiffAdd",
		R = "DiffChange",
		v = "Visual",
	}
	local highlightGroup = highlightGroupMap[mode]
	return highlightGroup ~= nil and highlightGroup or "Comment"
end

function pad(str, width)
	local len = string.len(str)
	local diff = width - len
	if diff < 0 then return str end
	return " " .. str .. string.rep(" ", diff - 1)
end

function StatusBarActive()
	local CtrlS = vim.api.nvim_replace_termcodes('<C-S>', true, true, true)
	local CtrlV = vim.api.nvim_replace_termcodes('<C-V>', true, true, true)
	local modesMap = {
		['n']   = 'Normal',
		['i']   = 'Insert',
		['R']   = 'Replace',
		['v']   = 'Visual',
		['V']   = 'V-Line',
		['s']   = 'Select',
		['S']   = 'S-Line',
		['c']   = 'Command',
		['r']   = 'Prompt',
		['!']   = 'Shell',
		['t']   = 'Terminal',
		[CtrlS] = 'S-Block',
		[CtrlV] = 'V-Block',
	}
	local mode = vim.fn.mode()
	local highlightGroup = getHighlightGroup(mode)
	local modeString = pad(modesMap[mode], 10)

	local encoding = vim.bo.fileencoding or vim.bo.encoding
	local format = vim.bo.fileformat

	return '%#' .. highlightGroup .. '#' .. modeString .. "%#StatusLine# %F%m%r" .. "%=" .. encoding .. " " .. format
end

function StatusBarInactive()
	return '%F'
end

function M.StatusBar()
	vim.go.statusline = '%{%(nvim_get_current_win()==#g:actual_curwin || &laststatus==3) ? v:lua.StatusBarActive() : v:lua.StatusBarInactive()%}'
end

return M
