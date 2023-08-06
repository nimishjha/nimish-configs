import sublime, sublime_plugin

class DisableCommandLoggingCommand(sublime_plugin.TextCommand):
	def run(self, edit):
		sublime.log_commands(False)
