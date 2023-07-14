import sublime
import sublime_plugin


class ConvertToTabsAndSetWidthCommand(sublime_plugin.WindowCommand):
	def run(self):
		self.window.run_command("unexpand_tabs", { "set_translate_tabs": "true" })
		self.window.run_command("set_setting", { "setting": "tab_size", "value": 8 })
