import os

from ranger.api.commands import Command

class prepend_aaa(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = "aaa " + file.relative_path
			if access(new_name, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists", bad=True)
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		return None

class batch_rename(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		new_base_name = self.rest(1)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = new_base_name + "%04d" % (index) + splitext(file.relative_path)[1]
			if access(new_name, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists", bad=True)
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch rename successful")

		return None

class remove_underscores(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = file.relative_path.replace("_", " ")
			if access(new_name, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists", bad=True)
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		return None

