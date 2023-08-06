import sublime, sublime_plugin

class CycleColorSchemeCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		direction = "next"
		if('direction' in kwargs):
			direction = kwargs['direction']
		preferences = sublime.load_settings('Preferences.sublime-settings')
		scheme = self.view.settings().get("color_scheme")
		schemes = [
			# "Packages/Nimish/Blue.tmTheme",
			# "Packages/Nimish/DeepBlue.tmTheme",
			"Packages/Nimish/BlueGreen.tmTheme",
			"Packages/Nimish/Arctic.tmTheme",
			"Packages/Nimish/BlueGreenDim.tmTheme",
			"Packages/Nimish/Random01.tmTheme",
			"Packages/Nimish/ArcticDim.tmTheme",
			# "Packages/Nimish/Red.tmTheme",
			# "Packages/Nimish/Orange.tmTheme",
			# "Packages/Nimish/Green.tmTheme",
			"Packages/Nimish/BlackAndWhite.tmTheme",
			# "Packages/Nimish/RedBlue.tmTheme",
  		]
		try:
			i = schemes.index(scheme)
			if direction == "next":
				newScheme = schemes[ (i+1) % len(schemes) ]
			else:
				newScheme = schemes[ (i-1) % len(schemes) ]
		except ValueError:
			newScheme = schemes[0]
		print('>>> Setting color scheme to ', newScheme)
		preferences.set('color_scheme', newScheme)
