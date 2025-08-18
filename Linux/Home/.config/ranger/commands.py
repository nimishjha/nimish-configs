import os

from ranger.api.commands import Command

def getFormattedModificationTime(filepath):
	from datetime import datetime
	modTime = os.path.getmtime(filepath)
	dateTime = datetime.fromtimestamp(modTime)
	return dateTime.strftime("%Y%m%d_%H%M%S")


class prefix(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access

		prefix = self.rest(1)
		if not prefix:
			return self.fm.notify("Prefix is required", bad=True)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = prefix + file.relative_path
			if access(new_name, os.F_OK):
				# return self.fm.notify("rename failed, file already exists", bad=True)
				new_name = prefix + "%04d" % (index) + file.relative_path
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch prefix successful")

		return None


class rename_basename(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		newBaseName = self.rest(1)

		if newBaseName:
			file = self.fm.thisfile
			basename = file.basename
			ext = splitext(file.relative_path)[1]
			newName = newBaseName + ext

			if access(newName, os.F_OK):
				return self.fm.notify("Cannot rename, file already exists", bad=True)

			try:
				os.rename(file.relative_path, newName)
			except OSError as err:
				self.fm.notify(err)
				return False

			self.fm.notify(f"Renamed {basename} to {newName}")
		else:
			self.fm.notify("Usage: rename_basename <newbasename>")

		return None


class batch_rename(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		new_base_name = self.rest(1)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = new_base_name + "%04d" % (index + 1) + splitext(file.relative_path)[1]
			if access(new_name, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists", bad=True)
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch rename successful")

		return None


class batch_rename_two_digits(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		new_base_name = self.rest(1)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			new_name = new_base_name + "%02d" % (index + 1) + splitext(file.relative_path)[1]
			if access(new_name, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists", bad=True)
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch rename successful")

		return None


class batch_rename_filemtime(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		newBaseName = self.rest(1)
		if not newBaseName:
			return self.fm.notify("Base name is required", bad=True)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			fileModTimeString = getFormattedModificationTime(file.path)
			newName = newBaseName + "_" + fileModTimeString + splitext(file.relative_path)[1]
			if access(newName, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists: " + newName, bad=True)
			try:
				os.rename(file.relative_path, newName)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch rename successful")

		return None


class setextension(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		from os.path import splitext

		newExtension = self.rest(1)
		if not newExtension:
			return self.fm.notify("Extension is required", bad=True)

		for index, file in enumerate( self.fm.thistab.get_selection() ):
			fileModTimeString = getFormattedModificationTime(file.path)
			newName = splitext(file.relative_path)[0] + "." + newExtension
			if access(newName, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists: " + newName, bad=True)
			try:
				os.rename(file.relative_path, newName)
			except OSError as err:
				self.fm.notify(err)
				return False

		self.fm.notify("Batch setextension successful")

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
				("\\[[A-Za-z0-9_-]+\\]", ""),
				("[\\._]", " "),
				("[^A-Za-z0-9 ]", " "),
				("\\s+", " "),
				(" s ", "s "),
				(" t ", "t "),
				("^\\s+", ""),
				("\\s+$", ""),
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


class sanitize_filename(Command):

	def execute(self):
		from ranger.container.file import File
		from os import access
		import os
		import re

		for index, file in enumerate(self.fm.thistab.get_selection()):
			base, ext = os.path.splitext(file.relative_path)
			new_base = re.sub(r'[^a-zA-Z0-9 ]', '', base).lower()
			new_base = re.sub(r'\s+', ' ', new_base)
			new_name = new_base + ext.lower()

			if access(new_name, os.F_OK):
				return self.fm.notify("Batch rename failed, file already exists", bad=True)
			try:
				os.rename(file.relative_path, new_name)
			except OSError as err:
				self.fm.notify(err)
				return False

		return None


class copy_and_increment(Command):
	def execute(self):
		from ranger.container.file import File
		from os import access
		import os
		import re
		import shutil

		for file in self.fm.thistab.get_selection():
			base, ext = os.path.splitext(file.basename)

			match = re.match(r'^(.*?)(\d+)$', base)
			if not match:
				self.fm.notify(f"File {file.basename} doesn't match expected pattern", bad=True)
				continue

			prefix, num = match.groups()
			new_num = int(num) + 1
			new_name = f"{prefix}{new_num:0{len(num)}d}{ext}"
			new_path = os.path.join(os.path.dirname(file.path), new_name)

			if access(new_path, os.F_OK):
				self.fm.notify(f"Copy failed, {new_name} already exists", bad=True)
				continue

			try:
				shutil.copy2(file.path, new_path)
				self.fm.notify(f"Copied {file.basename} to {new_name}")
			except OSError as err:
				self.fm.notify(f"Error copying {file.basename}: {err}", bad=True)
				continue

		return None


class compress7z(Command):
	def execute(self):
		commandString = "7z a -mx9 /mnt/ramdisk/"
		if self.arg(1):
			commandString += self.arg(1) + ".7z "
		else:
			commandString += "temp.7z "

		for index, file in enumerate(self.fm.thistab.get_selection()):
			commandString += '"' + file.path + '" '
		self.fm.execute_command(commandString)

		return None


class test(Command):
	def execute(self):
		if self.arg(1):
			self.fm.notify("arg(1) is " + self.arg(1))
		else:
			self.fm.notify("no args")
