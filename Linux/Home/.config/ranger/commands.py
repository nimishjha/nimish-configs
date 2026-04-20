import os
import re
import logging
from os.path import splitext
from ranger.api.commands import Command
from utils import notify, getStem, getExt, checkIfFileExists, getFormattedModificationTime, getSafeName, renameFileIncrementOnCollision, renameFileFailOnCollision, renameSequential, copyFile


logger = logging.getLogger("RangerCustomCommands")


class prefix(Command):
	def execute(self):
		prefix = self.rest(1)
		if not prefix:
			return self.fm.notify("Prefix is required", bad = True)

		numNotRenamed = sum( bool( renameFileIncrementOnCollision(file.relative_path, prefix + file.relative_path) ) for file in self.fm.thistab.get_selection() )
		if numNotRenamed > 0:
			self.fm.notify(f"{numNotRenamed} rename attempts failed", bad = True)
		else:
			self.fm.notify("All files renamed successfully")


class renameStem(Command):
	def execute(self):
		newStem = self.rest(1)
		if not newStem:
			self.fm.notify("Usage: renameStem <newStem>")
			return False

		selection = self.fm.thistab.get_selection()
		if len(selection) > 1:
			self.fm.notify("renameStem must only be called with one file selected")
			return False

		file = self.fm.thisfile
		newName = newStem + getExt(file.relative_path)
		error = renameFileFailOnCollision(file.relative_path, newName)
		notify(self.fm, error, f"Renamed {file.relative_path} to {newName}")


class batchRenameFourDigits(Command):
	def execute(self):
		prefix = self.rest(1)
		if not prefix:
			return self.fm.notify("A prefix is required", bad = True)
		selection = self.fm.thistab.get_selection()
		error = renameSequential(selection, prefix, 4)
		notify(self.fm, error, f"Renamed {len(selection)} files")


class batchRenameTwoDigits(Command):
	def execute(self):
		prefix = self.rest(1)
		if not prefix:
			return self.fm.notify("A prefix is required", bad = True)
		selection = self.fm.thistab.get_selection()
		error = renameSequential(selection, prefix, 2)
		notify(self.fm, error, f"Renamed {len(selection)} files")


class batchRenameFilemtime(Command):
	def execute(self):
		newBaseName = self.rest(1)
		if not newBaseName:
			return self.fm.notify("Base name is required", bad = True)

		selection = self.fm.thistab.get_selection()

		names = list()
		for index, file in enumerate(selection):
			name = newBaseName + "_" + getFormattedModificationTime(file.path) + splitext(file.relative_path)[1]
			if checkIfFileExists(name):
				return self.fm.notify(f"Cannot proceed with batch rename, there would be at least one collision with {name}", bad = True)
			names.append(name)

		numNotRenamed = 0
		for index, file in enumerate(selection):
			numNotRenamed += bool(renameFileIncrementOnCollision(file.relative_path, names[index]))

		if numNotRenamed > 0:
			self.fm.notify(f"There were {numNotRenamed} errors while renaming", bad = True)
		else:
			self.fm.notify("Batch rename successful")


class setExtension(Command):
	def execute(self):
		newExtension = self.args(1)
		if not newExtension:
			return self.fm.notify("Extension is required", bad = True)

		selection = self.fm.thistab.get_selection()

		names = list()
		for index, file in enumerate(selection):
			name = getStem(file.relative_path) + "." + newExtension
			if checkIfFileExists(name):
				return self.fm.notify(f"Cannot proceed, there would be at least one collision with {name}", bad = True)
			names.append(name)

		numNotRenamed = 0
		for index, file in enumerate(selection):
			numNotRenamed += bool(renameFileFailOnCollision(file.relative_path, names[index]))

		if numNotRenamed > 0:
			self.fm.notify(f"Failed to rename {numNotRenamed} files", bad = True)
		else:
			self.fm.notify(f"Set the extension to {newExtention} on {len(selection)} files")


class cleanupFilenames(Command):
	def execute(self):
		numNotRenamed = 0
		for file in enumerate( self.fm.thistab.get_selection() ):
			stem, ext = splitext(file.relative_path)
			replacements = [
				("\\[[A-Za-z0-9_-]+\\]", ""),
				("[\\._]", " "),
				("[^A-Za-z0-9 ]", " "),
				("\\s+", " "),
				(" s ", "s "),
				(" t ", "t "),
			]
			for pattern, replacement in replacements:
				stem = re.sub(pattern, replacement, stem)
			newName = stem.strip() + ext
			numNotRenamed += bool( renameFileFailOnCollision(file.relative_path, newName) )

		if numNotRenamed > 0:
			self.fm.notify(f"{numNotRenamed} rename attempts failed", bad = True)
		else:
			self.fm.notify(f"All files renamed successfully")


def sanitizeFilenameActual(file):
	stem, ext = os.path.splitext(file.relative_path)
	newStem = re.sub(r'[^a-zA-Z0-9 ]', '', stem).lower()
	newStem = re.sub(r'\s+', ' ', newStem)
	return newStem + ext.lower()


class sanitizeFilename(Command):
	def execute(self):
		numNotRenamed = 0
		for file in enumerate(self.fm.thistab.get_selection()):
			numNotRenamed += bool( renameFileIncrementOnCollision(file.relative_path, sanitizeFilenameActual(file)) )

		if numNotRenamed:
			self.fm.notify(f"{numNotRenamed} rename attempts failed", bad = True)


class copyAndIncrement(Command):
	def execute(self):
		for file in self.fm.thistab.get_selection():
			stem, ext = os.path.splitext(file.basename)

			match = re.match(r'^(.*?)(\d+)$', stem)
			if match:
				prefix, num = match.groups()
				newNum = int(num) + 1
				newName = f"{prefix}{newNum:0{len(num)}d}{ext}"
			else:
				newName = f"{stem}01{ext}"

			newSafeName = getSafeName(newName)

			if newSafeName:
				error = copyFile(file.basename, newSafeName)
				notify(self.fm, error, f"Copied {file.basename} to {newSafeName}")
			else:
				self.fm.notify(f"Could not get safe name for {newName}", bad = True)


class compress7z(Command):
	def execute(self):
		stem = self.arg(1)
		if not stem:
			self.fm.notify("A filename is required", bad = True)
			return False

		commandString = f"7z a -mx9 /mnt/ramdisk/{stem}.7z "

		files = list()
		for file in self.fm.thistab.get_selection():
			files.append('"' + file.path + '"')

		commandString += ' '.join(files)
		self.fm.execute_command(commandString)


def logItem(item):
	logger.info(f"\t item.basename:      {item.basename}")
	logger.info(f"\t item.relative_path: {item.relative_path}")
	logger.info(f"\t item.path:          {item.path}")
	logger.info(f"\t is_directory:       {item.is_directory}")
	logger.info(f"\t is_file:            {item.is_file}")
	logger.info(f"\t is_link:            {item.is_link}")
	logger.info(f"\t directory:          {os.path.dirname(item.path)}")


class test(Command):
	def execute(self):
		logger.info(" ")
		for index, arg in enumerate(self.args):
			logger.info(f"arg {index}: {arg}")

		logger.info(" ")
		for i in range(0, len(self.args)):
			logger.info(f"rest {i}: {self.rest(i)}")

		logger.info(" ")
		selection = self.fm.thistab.get_selection()
		logger.info(f"{len(selection)} items selected:")
		logger.info(" ")
		for item in self.fm.thistab.get_selection():
			logItem(item)
			logger.info(" ")

		logger.info("self.fm.thisfile:")
		logger.info(" ")
		logItem(self.fm.thisfile)
