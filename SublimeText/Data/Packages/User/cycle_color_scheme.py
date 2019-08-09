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
			"Packages/Nimish/Blue01.tmTheme",
			"Packages/Nimish/DeepBlue.tmTheme",
			"Packages/Nimish/Orange01.tmTheme",
			"Packages/Nimish/Green01.tmTheme",
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
			print("CycleColorSchemeCommand: exception")
