import os
import shutil
from os.path import splitext
from datetime import datetime


def notify(fm, errorMsg, successMsg):
	if errorMsg:
		fm.notify(errorMsg, bad = True)
	else:
		fm.notify(successMsg)


def getStem(filename):
	return splitext(filename)[0]


def getExt(filename):
	return splitext(filename)[1]


def checkIfFileExists(filename):
	return os.access(filename, os.F_OK)


def getFormattedModificationTime(filepath):
	modTime = os.path.getmtime(filepath)
	dateTime = datetime.fromtimestamp(modTime)
	return dateTime.strftime("%Y%m%d_%H%M%S")


def getSafeName(filenameWithoutPath):
	if '/' in filenameWithoutPath:
		return False

	stem, ext = splitext(filenameWithoutPath)
	testName = filenameWithoutPath
	for i in range (1, 9999):
		if checkIfFileExists(testName):
			num = "%04d" % (i)
			testName = f"{stem}_{num}{ext}"
		else:
			return testName

	return False


def renameFileIncrementOnCollision(oldName, newName):
	if oldName == newName:
		return "old and new names are identical"

	if '/' in oldName or '/' in newName:
		return "Names cannot include a directory separator"

	newSafeName = getSafeName(newName)
	if not newSafeName:
		return f"Could not get a safe name for {newName}"

	try:
		os.rename(oldName, newSafeName)
	except OSError as err:
		return err
	else:
		return ""


def renameFileFailOnCollision(oldName, newName):
	if oldName == newName:
		return "Old and new names are identical"

	if '/' in oldName or '/' in newName:
		return "Filenames cannot contain '/'"

	if checkIfFileExists(newName):
		return f"Cannot rename, {newName} already exists"

	try:
		os.rename(oldName, newName)
	except OSError as err:
		return err
	else:
		return ""


def copyFile(oldPath, newPath):
	try:
		shutil.copy2(oldPath, newPath)
	except OSError as err:
		return err
	else:
		return ""


def renameSequential(selection, prefix, numDigits):
	if len(selection) > pow(10, numDigits):
		return "Not enough digits for the number of files"

	names = list()
	for index, file in enumerate(selection):
		name = f"{prefix}{(index+1):0{numDigits}d}{getExt(file.relative_path)}"
		if checkIfFileExists(name):
			return f"Cannot proceed with batch rename, there would be at least one collision with {name}"
		names.append(name)

	numNotRenamed = 0
	for index, file in enumerate(selection):
		numNotRenamed += bool(renameFileIncrementOnCollision(file.relative_path, names[index]))

	if numNotRenamed > 0:
		return f"There were {numNotRenamed} errors while renaming"
	else:
		return ""
