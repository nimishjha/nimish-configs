
import sublime, sublime_plugin

class CycleFontCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		preferences = sublime.load_settings('Preferences.sublime-settings')
		current_font = self.view.settings().get("font_face")
		fonts = [
			["Swis721CnBTCode", 17],
			["Verdcode", 14],
			["Consolas", 15],
			["Menlo Bold for Powerline", 12],
		]
		num_fonts = len(fonts)
		new_index = -1
		for i in range(num_fonts):
			font = fonts[i]
			if(font[0] == current_font):
				new_index = (i + 1) % len(fonts)
				break
		if(new_index == -1):
			new_index = 0
		new_font = fonts[new_index][0]
		new_font_size = fonts[new_index][1]
		preferences.set('font_face', new_font)
		preferences.set('font_size', new_font_size)
