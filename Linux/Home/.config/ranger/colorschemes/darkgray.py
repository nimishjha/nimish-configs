from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class DarkGray(ColorScheme):
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
			if context.audio:
				fg = 136
			if context.video:
				fg = 33
			if context.image:
				fg = 69
			if context.document:
				fg = 115
			if context.customtype01:
				fg = 134
			if context.customtype02:
				fg = 73
			if context.customtype03:
				attr |= bold
				fg = 99
			if context.customtype04:
				attr |= bold
				fg = 105
			if context.customtype05:
				fg = 40
			if context.customtype06:
				fg = 130
			if context.customtype07:
				fg = 172
			if context.container:
				attr |= bold
				fg = 111
			if context.marked:
				bg = 17
			if context.directory:
				attr |= bold
				fg = 248
			elif context.executable and not any((context.media, context.container, context.fifo, context.socket)):
				attr |= bold
				fg = red
				fg += BRIGHT
			if context.link:
				if context.bad:
					fg = 93
				else:
					fg = 226
			if context.selected:
				# attr = reverse
				# fg = 226
				# bg = 20
				bg = 236
			if context.cut:
				bg = 52
				# fg = 252
			if context.copied:
				bg = 55
				fg = 252
			if context.marked and context.selected:
				bg = 20
			if context.copied and context.selected:
				bg = 57
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
				fg = 116
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
				fg += BRIGHT
			if context.frozen:
				attr |= bold | reverse
				fg = cyan
				fg += BRIGHT
			if context.message:
				if context.bad:
					attr |= bold
					fg = red
					fg += BRIGHT
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
