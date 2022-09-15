extends Node


## A generic saving function
## dataToSave: the var you want to save
## fileName: i.e. "user://data.txt"
## dataTypes: use "String" or "float"
func genericSaver(dataToSave, fileName: String, dataType: String):
	var file = File.new()
	file.open(fileName, File.WRITE)
	
	if dataType == "String":
		file.store_string(dataToSave as String)
	if dataType == "float":
		file.store_float(dataToSave as float)
	
	file.close()

func genericLoader(fileName: String, dataType: String):
	var file = File.new()
	var finalData
	file.open(fileName, File.READ)
	
	if dataType == "String":
		finalData = file.get_as_text()
	if dataType == "float":
		finalData = file.get_float()
	
	file.close()
	return finalData

#TODO: delete when old game mode is gone
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
