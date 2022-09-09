extends Node

func saver(dataToSave):
	var file = File.new()
	file.open("user://data.txt", File.WRITE)
	file.store_string(dataToSave as String)
	file.close()

func loader():
	var file = File.new()
	file.open("user://data.txt", File.READ)
	var textInTheFile = file.get_as_text()
	file.close()

	return textInTheFile

#TODO: this needs to be different
func hpSaver(dataToSave):
	var file = File.new()
	file.open("user://data2.txt", File.WRITE)
	file.store_float(dataToSave as float)
	file.close()
func hpLoader():
	var file = File.new()
	file.open("user://data2.txt", File.READ)
	var textInTheFile = file.get_float()
	file.close()

	return textInTheFile

# -- ENDLESS MODE --
func endlessSaver(dataToSave):
	var file = File.new()
	file.open("user://endless1.txt", File.WRITE)
	file.store_string(dataToSave as String)
	file.close()
func endlessHpSaver(dataToSave):
	var file = File.new()
	file.open("user://endless2.txt", File.WRITE)
	file.store_float(dataToSave as float)
	file.close()

func endlessLoader():
	var file = File.new()
	file.open("user://endless1.txt", File.READ)
	var textInTheFile = file.get_as_text()
	file.close()
	return textInTheFile
func endlessHpLoader():
	var file = File.new()
	file.open("user://endless2.txt", File.READ)
	var textInTheFile = file.get_float()
	file.close()
	return textInTheFile