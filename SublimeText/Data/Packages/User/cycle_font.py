import sublime, sublime_plugin

class CycleFontCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		preferences = sublime.load_settings('Preferences.sublime-settings')
		current_font = self.view.settings().get("font_face")
		fonts = [
			["Swis721CnBTCode", 17, []],
			["Monospace", 12, ["bold"]],
			["SF Mono", 12, [ "bold" ]],
			# ["Swis721 Cn BT", 16, ["bold"]],
			# ["Consolas", 14, ["bold" ]],
			# ["JetBrains Mono NL", 14, ["bold"]],
			# ["Consolas", 14, ["normal"]],
			# ["Menlo Bold for Powerline", 12, []],
			# ["Arial", 13, ["bold"]],
			# ["Verdcode", 11, ["bold"]],
			# ["Tahoma", 13, ["bold"]],
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
		preferences.set('font_face', new_font)
		preferences.set('font_size', new_font_size)
		preferences.set('font_options', new_font_options)
