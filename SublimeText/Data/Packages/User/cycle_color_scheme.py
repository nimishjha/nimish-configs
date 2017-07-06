#
#	http://kylebebak.github.io/post/cycle-color-theme
#
import sublime, sublime_plugin
class CycleColorSchemeCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		preferences = sublime.load_settings('Preferences.sublime-settings')
		scheme = self.view.settings().get("color_scheme")
		try:
			schemes = kwargs.get("color_schemes")
			i = schemes.index(scheme)
			preferences.set('color_scheme', schemes[ (i+1) % len(schemes) ])
		except ValueError:
			preferences.set('color_scheme', schemes[0])
		except Exception:
			print("Something went wrong.")
