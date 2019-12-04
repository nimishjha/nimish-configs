# https://stackoverflow.com/questions/25774352/how-could-i-use-per-folder-color-schemes-sublime-text-3

import sublime, sublime_plugin
class ColorSchemeByPathCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		settings = self.view.settings()
		if "/bupa-com-au-FE/" in self.view.file_name():
			print("FRONT END")
			settings.set('color_scheme', 'Packages/User/Nimish/Blue01.tmTheme')
		elif "/bupa-com-au/" in self.view.file_name():
			print("BACK END")
			# settings.set('color_scheme', 'Packages/User/Nimish/Orange01.tmTheme')
			settings.set('color_scheme', 'Packages/User/Nimish/BrightOrange.tmTheme')
class ColorSchemeByPathEventListener(sublime_plugin.EventListener):
	def on_load_async(self, view):
		view.run_command("color_scheme_by_path")
