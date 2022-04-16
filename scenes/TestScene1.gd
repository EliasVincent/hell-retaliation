extends Node2D

onready var animationPlayer = $AnimationPlayer
export var playLevelAnimation = true

func _ready():
	if playLevelAnimation:
		animationPlayer.play("LEVEL")
