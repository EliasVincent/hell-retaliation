extends Node2D

# StateManager will load all Stages from prefab/stages/ and will load them in order.
# To progress to the next stage, the Player either has to kill all enemies in the "ENEMIES" group or wait for the timer to expire.
# to add a level to the game, create a new match for levelToPlay 2. It will load all stages from the prefab/stages/L2 folder
export (int) var levelToPlay = 1

var stageList : Array
var currStageCount : int
var currStage

var willSwitch : bool = false

var totalStages : int

onready var stageTimer = $StageTimer
export (float) var timePerStage = 20.0

func list_files_in_directory(path):
	var files = []
	var dir = Directory.new()
	dir.open(path)
	dir.list_dir_begin()

	while true:
		var file = dir.get_next()
		if file == "":
			break
		elif not file.begins_with("."):
			if file.ends_with(".tscn"):
				files.append(file)

	dir.list_dir_end()
	return files

func _ready():
	var levelFolder : String
	
	currStageCount = 0
	match levelToPlay:
		# TODO: Refactor on multiple levels
		1:
			levelFolder = "L1"

	var levelFolderPath : String = str("res://prefab/stages/", levelFolder)
	var stageFilesList = list_files_in_directory(levelFolderPath)
	print(stageFilesList)
	for stage in stageFilesList:
		var pathString: String = str(levelFolderPath , "/" , stage) 
		print(pathString)
		var instance = load(pathString)
		stageList.append(instance)
		# after it's done it would spam nulls, no idea why
		if stage == null:
			break
	totalStages = stageList.size()
	
	# compared to array size soo it do be like that
	totalStages -= 1
	
func _process(delta):
	# this will be a mess. DO NOT PUT ENEMIES OUTSIDE STAGES IN ENEMY GROUP
	# If you want ie a bossfight that boss should be it's own group
	var numOfEnemies = get_tree().get_nodes_in_group("ENEMY").size()
	
	if numOfEnemies <= 0:
		willSwitch = true
	
	if willSwitch:
		if currStageCount > totalStages:
			win()
			willSwitch = false
		else:
			instanceNextScene()
			currStageCount += 1
			willSwitch = false
		
func win():
	print("YOU WIN")
func instanceNextScene():
	currStage = stageList[currStageCount]
#	currStage = stageList[1]
	var currStageInstance = currStage.instance()
	get_parent().add_child_below_node(self, currStageInstance);
	
	stageTimer.stop()
	stageTimer.start(timePerStage)


func _on_StageTimer_timeout():
	pass
	# get all remaining ENEMY 
	var remainingEnemies = get_tree().get_nodes_in_group("ENEMY")
	for enemy in remainingEnemies:
		#TODO: handle die()
		# remove from ENEMY group -> 0 in group -> next stage
		enemy.remove_from_group("ENEMY")
		# get animationPlayer of node
		var animPlayer = enemy.get_node("AnimationPlayer")
		animPlayer.play("DIE")
	# switch to next scene while keeping old enemies for ~5 seconds
