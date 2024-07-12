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

class prefix(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access

		prefix = self.rest(1)
		if not prefix:
			return self.fm.notify("Prefix is required", bad=True)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = prefix + " " + file.relative_path
			if access(new_name, os.F_OK):
				# return self.fm.notify("rename failed, file already exists", bad=True)
				new_name = prefix + "%04d" % (index) + " " + file.relative_path
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch prefix successful")

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


class cleanup_filenames(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext
		import re

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			splat = splitext(file.relative_path)
			base_name = splat[0]
			extension = splat[1]
			replacements = [
				("\[[A-Za-z0-9_-]+\]", ""),
				("[\._]", " "),
				("[^A-Za-z0-9 ]", " "),
				("\s+", " "),
				(" s ", "s "),
				(" t ", "t "),
				("^\s+", ""),
				("\s+$", ""),
			]
			for pattern, replacement in replacements:
				base_name = re.sub(pattern, replacement, base_name)
			new_name = base_name + extension
			count = 0
			while access(new_name, os.F_OK) and count < 10:
				new_name = base_name + "_" + "%02d" % (count) + extension
				count += 1
			if access(new_name, os.F_OK):
				continue
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		return None

