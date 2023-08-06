import sublime, sublime_plugin

class EnableCommandLoggingCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		sublime.log_commands(True)
