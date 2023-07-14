import sublime, sublime_plugin, re

class NormalizeWhitespaceCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		view = self.view
		region = view.sel()[0]
		if region:
			selectionText = view.substr(region)
			normalizedText = re.sub(r"\s+", " ", selectionText)
			view.replace(edit, region, normalizedText)

