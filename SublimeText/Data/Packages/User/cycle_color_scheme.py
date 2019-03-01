#
#	http://kylebebak.github.io/post/cycle-color-theme
#
import sublime, sublime_plugin
class CycleColorSchemeCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		preferences = sublime.load_settings('Preferences.sublime-settings')
		scheme = self.view.settings().get("color_scheme")
		print("Previous: " + scheme);
		schemes = [
			"Packages/User/SublimeLinter/Blue01 (SL).tmTheme",
			"Packages/User/SublimeLinter/DeepBlue (SL).tmTheme",
			"Packages/User/SublimeLinter/Orange01 (SL).tmTheme",
			"Packages/User/SublimeLinter/Green01 (SL).tmTheme",
  		]
		try:
			i = schemes.index(scheme)
			newScheme = schemes[ (i+1) % len(schemes) ]
			preferences.set('color_scheme', newScheme)
			scheme = self.view.settings().get("color_scheme")
			print("New:      " + newScheme)
		except ValueError:
			preferences.set('color_scheme', schemes[0])
		except Exception:
			print("Something went wrong.")


