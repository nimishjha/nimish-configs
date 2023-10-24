from ranger.gui.colorscheme import ColorScheme
from ranger.gui.color import *

class MostlyGray(ColorScheme):
	progress_bar_color = 33

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
				fg = 178
			if context.video:
				fg = 33
			if context.image:
				fg = 42
			if context.document:
				fg = 45
			if context.container:
				attr |= bold
				fg = 111
			if context.link:
				fg = cyan if context.good else magenta
			if context.marked:
				bg = 19
			if context.directory:
				attr |= bold
				fg = 7
			if context.link:
				fg = context.good and 129 or 21
				bg = 234
			if context.selected:
				# attr = reverse
				# fg = 226
				# bg = 20
				bg = 236
			if context.cut:
				bg = 88
				fg = 252
			if context.copied:
				bg = 55
				fg = 252
			if context.marked and context.selected:
				bg = 21
			if context.copied and context.selected:
				bg = 57
			if context.cut and context.selected:
				bg = 124
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
					fg = 51
			elif context.directory:
				fg = 51
			elif context.tab:
				if context.good:
					bg = 250
					fg = 0
				else:
					bg = 238
					fg = 252
			elif context.link:
				fg = 116
			else:
				fg = 145

		elif context.in_statusbar:
			fg = 7

		return fg, bg, attr
