import sublime, sublime_plugin

class CycleColorSchemeCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		direction = "next"
		if('direction' in kwargs):
			direction = kwargs['direction']
		preferences = sublime.load_settings('Preferences.sublime-settings')
		scheme = self.view.settings().get("color_scheme")
		schemes = [
			"Packages/CustomColorSchemes/Blue.tmTheme",
			"Packages/CustomColorSchemes/DeepBlue.tmTheme",
			"Packages/CustomColorSchemes/BlueGreen.tmTheme",
			"Packages/CustomColorSchemes/DeepBlueDim.tmTheme",
			"Packages/CustomColorSchemes/BlueGreenDim.tmTheme",
			"Packages/CustomColorSchemes/Arctic.tmTheme",
			"Packages/CustomColorSchemes/ArcticDim.tmTheme",
			"Packages/CustomColorSchemes/BlackAndWhite.tmTheme",
			"Packages/CustomColorSchemes/Taupe.tmTheme",
			"Packages/CustomColorSchemes/Red.tmTheme",
			"Packages/CustomColorSchemes/OrangeDim.tmTheme",
			"Packages/CustomColorSchemes/Green.tmTheme",
			"Packages/CustomColorSchemes/GreenDim.tmTheme",
			"Packages/CustomColorSchemes/RedBlue.tmTheme",
  		]
		try:
			i = schemes.index(scheme)
			if direction == "next":
				newScheme = schemes[ (i+1) % len(schemes) ]
			else:
				newScheme = schemes[ (i-1) % len(schemes) ]
		except ValueError:
			newScheme = schemes[0]
		print("Setting color scheme to ", newScheme)
		preferences.set('color_scheme', newScheme)
