# https://stackoverflow.com/questions/25774352/how-could-i-use-per-folder-color-schemes-sublime-text-3

import sublime, sublime_plugin
class ColorSchemeByPathCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		settings = self.view.settings()
		if "/test/" in self.view.file_name():
			settings.set('color_scheme', "Packages/User/SublimeLinter/Orange01 (SL).tmTheme")
		# elif "/client/" in self.view.file_name():
		else if "/direct-web/" in self.view.file_name():
			settings.set('color_scheme', "Packages/User/SublimeLinter/Blue01 (SL).tmTheme")
class ColorSchemeByPathEventListener(sublime_plugin.EventListener):
	def on_load_async(self, view):
		view.run_command("color_scheme_by_path")
