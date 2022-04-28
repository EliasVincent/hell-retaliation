extends Node2D

onready var spawnTimer = $SpawnTimer
onready var healthPack = preload("res://actors/HealthPack.tscn")

var windowX = Game.size.x
var windowY = Game.size.y

export (float) var spawnTime = 5.0

func _ready():
	spawn_healthPack()

func _on_SpawnTimer_timeout():
	spawn_healthPack()

func spawn_healthPack():
	# instance a healthPack at a random position inside of windowX and windowY
	var healthPackInstance = healthPack.instance()
	healthPackInstance.position = Vector2(
		rand_range(0, windowX),
		rand_range(0, windowY)
	)
	add_child(healthPackInstance)
	spawnTimer.start(spawnTime)
	
