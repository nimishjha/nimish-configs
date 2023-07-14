# based on https://gist.github.com/jugyo/5036719

import sublime_plugin

class FileNameOnStatusBar(sublime_plugin.EventListener):
	def on_activated(self, view):
		file_name = view.file_name()
		view_name = view.name()
		if file_name:
			for folder in view.window().folders():
				file_name = file_name.replace(folder + '/', '', 1)
			view.set_status('file_name', file_name)
		else:
			view.set_status('file_name', view_name)
