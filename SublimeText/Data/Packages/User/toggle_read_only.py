import sublime, sublime_plugin
class ToggleReadOnlyCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		view = self.view
		if(view.is_read_only()):
			currentViewSettings = view.settings()
			currentViewSettings.set("color_scheme", "Packages/Nimish/Orange02.tmTheme");
			view.set_read_only(False)
		else:
			currentViewSettings = view.settings()
			currentViewSettings.set("color_scheme", "Packages/Nimish/Blue01.tmTheme");
			view.set_read_only(True)
