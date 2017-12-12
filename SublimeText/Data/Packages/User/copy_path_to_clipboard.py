#
#		https://forum.sublimetext.com/t/file-name-and-full-path-to-clipboard/4833/9
#

import sublime, sublime_plugin, os
class FilenameToClipboardCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		sublime.set_clipboard(os.path.basename(self.view.file_name()))
class PathToClipboardCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		sublime.set_clipboard(self.view.file_name())
