extends Node2D

onready var sprite = $Sprite
onready var viewport = $Viewport


func _ready():
	var vp = viewport.get_texture()
	sprite.texture = vp
	# playerHP
	var hpToApply: float = SaveManager.hpLoader()
	print("Attempting to apply ", hpToApply, "onto ", GlobalVariables.playerHP)
	GlobalVariables.playerHP = hpToApply
