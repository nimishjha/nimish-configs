import sublime, sublime_plugin

class CycleColorSchemeCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		direction = "next"
		if('direction' in kwargs):
			direction = kwargs['direction']
		preferences = sublime.load_settings('Preferences.sublime-settings')
		scheme = self.view.settings().get("color_scheme")
		schemes = [
			"Packages/Nimish/Blue01.tmTheme",
			"Packages/Nimish/DeepBlue.tmTheme",
			"Packages/Nimish/Orange01.tmTheme",
			"Packages/Nimish/Orange02.tmTheme",
			"Packages/Nimish/BlackAndWhite.tmTheme",
			"Packages/Nimish/DesaturatedRedBlue.tmTheme",
  		]
		i = schemes.index(scheme)
		if direction == "next":
			newScheme = schemes[ (i+1) % len(schemes) ]
		else:
			newScheme = schemes[ (i-1) % len(schemes) ]
		preferences.set('color_scheme', newScheme)
		scheme = self.view.settings().get("color_scheme")
