from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

import ranger.customizations.extensionsasbitmask as extasbitmask

COLORS_BY_EXTENSION = {
	'NOEXT':        240,

	'jpg':          100,
	'jpeg':         101,
	'png':          102,
	'webp':         103,
	'gif':          104,
	'bmp':          105,
	'svg':          106,

	'mkv':          173,
	'webm':         176,
	'mp4':          175,
	'm2ts':         173,
	'wmv':          174,
	'avi':          175,
	'mov':          176,
	'mpg':          177,
	'm4v':          178,
	'flv':          179,
	'3gp':          179,

	'flac':         120,
	'ogg':          121,
	'ape':          122,
	'opus':         123,
	'mp3':          124,
	'aac':          125,
	'wav':          126,
	'm4a':          127,

	'epub':         130,
	'mobi':         131,
	'azw':          132,
	'azw3':         133,
	'htmlz':        134,

	'rar':          140,
	'zip':          141,
	'7z':           142,
	'gz':           143,
	'xz':           144,
	'bz':           145,
	'bz2':          146,

	'c':            150,
	'cpp':          151,
	'lua':          152,
	'js':           153,
	'glsl':         153,
	'hlsl':         152,
	'php':          153,
	'py':           150,
	'sh':           155,
	'go':           150,
	'rb':           151,
	'odin':         152,

	'rs':           160,
	'fx':           161,
	'zig':          162,
	'mjs':          163,
	'ts':           164,
	'tsx':          164,

	'bash_profile': 170,
	'bashrc':       171,
	'css':          172,
	'json':         173,
	'conf':         174,
	'yaml':         175,
	'toml':         176,
	'h':            177,
	'hpp':          178,
	'gitignore':    179,

	'log':          180,
	'txt':          181,
	'md':           182,
	'csv':          183,

	'html':         195,
	'htm':          196,
	'xml':          197,

	'pdf':          207,
	'djvu':         205,
}

NO_COLOR_FOUND = 239

def getFgByExtension(context):
	ext = extasbitmask.getExtensionFromBits([context.exbit0, context.exbit1, context.exbit2, context.exbit3, context.exbit4, context.exbit5, context.exbit6, context.exbit7])
	return COLORS_BY_EXTENSION.get(ext) or NO_COLOR_FOUND

class Bitwise(ColorScheme):
	progress_bar_color = 240

	def use(self, context):
		fg, bg, attr = default_colors
		fg = 7
		default_bg = bg
		attr = dim

		if context.reset:
			return default_colors

		elif context.in_browser:
			if context.border:
				fg = 240

			if context.exbit0 is not None:
				fg = getFgByExtension(context)

			if context.container:
				attr |= bold
				fg = 120
			if context.marked:
				bg = 234
			if context.directory:
				attr |= bold
				fg = 246
			elif context.executable and not any((context.media, context.container, context.fifo, context.socket)):
				attr |= bold
				fg = red
			if context.link:
				if context.bad:
					fg = 221
				else:
					fg = 220
			if context.selected:
				bg = 236
			if context.cut:
				bg = 52
			if context.copied:
				bg = 17
				fg = 15
			if context.marked and context.selected:
				bg = 233
			if context.copied and context.selected:
				bg = 233
			if context.cut and context.selected:
				bg = 88
			if not(context.main_column):
				fg = 240
				if context.selected:
					bg = 0
			if context.inactive_pane:
				fg = 240
				if context.selected:
					bg = 0

		elif context.in_titlebar:
			attr |= bold
			if context.hostname:
				if context.bad:
					fg = 124
				else:
					fg = 237
			elif context.directory:
				fg = 244
			elif context.tab:
				if context.good:
					bg = 235
					fg = 7
				else:
					bg = 239
					fg = 7
			elif context.link:
				fg = 220
			else:
				fg = 7

		elif context.in_statusbar:
			if context.permissions:
				if context.good:
					fg = cyan
				elif context.bad:
					fg = magenta
			if context.marked:
				attr |= bold | reverse
				fg = yellow
			if context.frozen:
				attr |= bold | reverse
				fg = cyan
			if context.message:
				if context.bad:
					attr |= bold
					fg = red
			if context.loaded:
				bg = self.progress_bar_color
			if context.vcsinfo:
				fg = blue
				attr &= ~bold
			if context.vcscommit:
				fg = yellow
				attr &= ~bold
			if context.vcsdate:
				fg = cyan
				attr &= ~bold

		return fg, bg, attr
