import sublime, sublime_plugin, re

class ReformatHtmlCommand(sublime_plugin.TextCommand):
	def run(self, edit, **kwargs):
		view = self.view
		region = sublime.Region(0, view.size())
		viewText = view.substr(region)
		normalizedText = re.sub(r"\s+", " ", viewText)
		normalizedText = re.sub(r"(<div|<h|<p|<bl|<sec|<me|<st|<bo|<ti|</he|</bo|</ht)", "\n\\1", normalizedText)
		view.replace(edit, region, normalizedText)

