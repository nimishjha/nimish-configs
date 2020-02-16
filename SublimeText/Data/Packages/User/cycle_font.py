import sublime, sublime_plugin
class CycleFontCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		preferences = sublime.load_settings('Preferences.sublime-settings')
		current_font = self.view.settings().get("font_face")
		current_font_size = self.view.settings().get("font_size")
		try:
			font_faces = ["Swis721CnBTCode", "Verdcode", "Consolas"]
			font_sizes = { "Swis721CnBTCode": 18, "Verdcode": 9, "Consolas": 18 }
			current_font_index = font_faces.index(current_font)
			new_font = font_faces[ (current_font_index + 1) % len(font_faces) ]
			new_font_size = font_sizes[new_font]
			print(new_font, new_font_size)
			preferences.set('font_face', new_font)
			preferences.set('font_size', new_font_size)
		except ValueError:
			print("ValueError")
		except Exception:
			print("Exception")
