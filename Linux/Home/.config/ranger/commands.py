import os
import re
import pprint
import logging
from operator import attrgetter
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


class batchRenameFourDigitsBySizeDescending(Command):
	def execute(self):
		prefix = self.rest(1)
		if not prefix:
			return self.fm.notify("A prefix is required", bad = True)

		selection = self.fm.thistab.get_selection()
		selection.sort(key = attrgetter("size"), reverse = True)
		error = renameSequential(selection, prefix, 4)
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
		if len(self.args) != 2:
			return self.fm.notify("Usage: setExtension <ext>", bad = True)

		newExtension = self.args[1]
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


class removeFromFilenames(Command):
	def execute(self):
		if len(self.args) != 2:
			return self.fm.notify("Usage: removeFromFilenames <searchString>", bad = True)

		searchStr = self.args[1]

		selection = self.fm.thistab.get_selection()

		names = list()
		for index, file in enumerate(selection):
			stem, ext = os.path.splitext(file.relative_path)
			if searchStr in stem:
				stem = stem.replace(searchStr, "").strip()
				name = stem + ext if len(ext) else stem
				if checkIfFileExists(name):
					return self.fm.notify(f"Cannot proceed, there would be at least one collision with {name}", bad = True)
				names.append(name)

		numNotRenamed = 0
		for index, file in enumerate(selection):
			numNotRenamed += bool(renameFileFailOnCollision(file.relative_path, names[index]))

		if numNotRenamed > 0:
			self.fm.notify(f"Failed to rename {numNotRenamed} files", bad = True)
		else:
			self.fm.notify(f"Removed the string {searchStr} from {len(selection)} names")


class cleanupFilenames(Command):
	def execute(self):
		numNotRenamed = 0
		for file in self.fm.thistab.get_selection():
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
		for file in self.fm.thistab.get_selection():
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


def getProperties(obj: object, properties: list[str]) -> dict:
	return {prop: getattr(obj, prop, "PROPERTY_DOES_NOT_EXIST") for prop in properties}


def listItemProperties(item):
	for dirItem in dir(item):
		if not "__" in dirItem:
			logger.info("\t\t" + dirItem)


def logItem(item):
	fileInfoDict = getProperties(item, ["path", "realpath", "basename", "dirname", "extension", "relative_path", "_mimetype", "size"])
	logger.info("")
	for key in fileInfoDict.keys():
		logger.info(f"\t{key:{24}} {fileInfoDict[key]}")


class debugFileInfo(Command):
	def execute(self):
		logItem(self.fm.thisfile)

