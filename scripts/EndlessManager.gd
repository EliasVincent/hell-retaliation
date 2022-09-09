extends Node2D

# ENEMIES
var enemiesToInclude: Array
onready var clockSpawner = preload("res://actors/ClockSpawner.tscn")
onready var bombSpawner = preload("res://actors/BombSpawner.tscn")

export var currStageCount : int
var currStage

var willSwitch : bool = false

onready var stageTimer = $StageTimer

export (float) var timePerStage = 60.0

# RNG Values for spawning
var clockSpawnerRngValues = {
	"minHp" : 10,
	"maxHp" : 15,
	"minSpeed" : 80,
	"maxSpeed" : 250,
}


func _ready():
	# loading currStageCount from save
	# we subtract 1 cause totalStages
	if GlobalVariables.loadLastSave == true:
		currStageCount = SaveManager.endlessLoader() as int
		if currStageCount > 0:
			currStageCount -= 1
	elif GlobalVariables.loadLastSave == false:
		currStageCount = 0
	
	GlobalVariables.initialStageTime = timePerStage

func _process(delta):
	# this will be a mess. DO NOT PUT ENEMIES OUTSIDE STAGES IN ENEMY GROUP
	# If you want ie a bossfight that boss should be it's own group
	var numOfEnemies = get_tree().get_nodes_in_group("ENEMY").size()
	
	if numOfEnemies <= 0:
		willSwitch = true
	
	if willSwitch:
		instanceNextScene()
		currStageCount += 1
		SaveManager.endlessSaver(currStageCount)
		SaveManager.endlessHpSaver(GlobalVariables.playerHP)
		print("SAVED: ", currStageCount as int, "HP SAVED: ",GlobalVariables.playerHP)
		willSwitch = false
	GlobalVariables.stageTimer = stageTimer.time_left

func instanceNextScene():
	match_enemies_to_include()

	var newStage = create_new_stage(currStageCount)

	currStage = newStage
	get_parent().add_child_below_node(self, currStage);

	stageTimer.stop()
	stageTimer.start(timePerStage)


func create_new_stage(currStageCount):
	var stage = Node2D.new()
	# Anzahl an Gegnern
	for i in rand_range(2,5):
		# instance enemy out of the inclusion array
		var enemy = enemiesToInclude[randi() % enemiesToInclude.size()].instance()
		stage.add_child(enemy)
		var enemyManager = enemy.get_node("EnemyManager")
		# setze die Position des Gegners
		enemy.position = Vector2(rand_range(256, get_viewport_rect().size.x - 256), rand_range(80, get_viewport_rect().size.y - 80))
		# prevent enemy overlap
		for j in i:
			# wenn die Positionen der Gegner zu nah beieinander sind
			if stage.get_child(j).position.distance_to(enemy.position) < 60:
				# setze die Position des Gegners neu
				enemy.position = Vector2(rand_range(0, get_viewport_rect().size.x), rand_range(0, get_viewport_rect().size.y))
				# setze den counter auf 0, damit alle Gegner nochmal überprüft werden
				j = 0
		
		# --- VAR RNG ---
		# enemy variable variationen
		enemy.min_rotation = rand_range(10, 100)
		enemy.max_rotation = rand_range(100, 360)

		if enemy.is_in_group("CLOCK_SPAWNER"):
			enemy.number_of_bullets = rand_range(3, 8)
			enemyManager.hp = rand_range(clockSpawnerRngValues.minHp, clockSpawnerRngValues.maxHp)
		
		if enemy.is_in_group("BOMB_SPAWNER"):
			#enemy.changeColorAfterShot = randi() % 2 == 0
			var oneOrZero = randi() % 2
			if oneOrZero == 0:
				enemy.bulletColor = "A"
			else:
				enemy.bulletColor = "B"


		enemy.bullet_speed = rand_range(clockSpawnerRngValues.minSpeed, clockSpawnerRngValues.maxSpeed)
		enemy.bulletRotationChange = rand_range(0, 15)
	return stage


func match_enemies_to_include():
	enemiesToInclude = []
	enemiesToInclude.append(clockSpawner)
	if currStageCount > 4:
		enemiesToInclude.append(bombSpawner)
		clockSpawnerRngValues.minHp = 12
		clockSpawnerRngValues.maxHp = 18


func _on_StageTimer_timeout():
	# get all remaining ENEMY 
	var remainingEnemies = get_tree().get_nodes_in_group("ENEMY")
	for enemy in remainingEnemies:
		#TODO: handle this mess AAAAAA
		#this could be enemy.die()??
		# remove from ENEMY group -> 0 in group -> next 
		
		enemy.remove_from_group("ENEMY")
		enemy.queue_free()
		# get animationPlayer of node
		var animPlayer = enemy.get_node("AnimationPlayer")
		animPlayer.play("DIE")
