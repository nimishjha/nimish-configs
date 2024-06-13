import sublime, sublime_plugin

class CycleFontCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		sublime.log_commands(False)
		preferences = sublime.load_settings('Preferences.sublime-settings')
		current_font = self.view.settings().get("font_face")
		fonts = [
			# ["Swis721CnBTCode", 13, []],
			["Swis721 Cn BT", 13, ["bold"]],
			["SF Mono", 10, ["bold"]],
			["Monospace", 10, ["bold"]],
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
		new_font_options = fonts[new_index][2]
		print("Setting font to ", new_font, new_font_size, new_font_options)
		preferences.set('font_face', new_font)
		preferences.set('font_size', new_font_size)
		preferences.set('font_options', new_font_options)
