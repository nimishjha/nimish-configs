import sublime, sublime_plugin
class CycleFontCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		preferences = sublime.load_settings('Preferences.sublime-settings')
		current_font = self.view.settings().get("font_face")
		current_font_size = self.view.settings().get("font_size")
		try:
			fonts = ["Verdcode", "Consolas", "Menlo"]
			current_font_index = fonts.index(current_font)
			new_font = fonts[ (current_font_index + 1) % len(fonts) ]
			preferences.set('font_face', new_font)

			if new_font == "Swis721CnBtCode":
				preferences.set('font_size', 18)
			elif new_font == "Verdcode":
				preferences.set('font_size', 15)
			else:
				preferences.set('font_size', 16)

		except ValueError:
			print("Your current color scheme doesn't match any of your args.")
		except Exception:
			print("Something went wrong.")
