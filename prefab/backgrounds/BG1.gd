extends Node2D

onready var viewport = $Viewport
onready var sprite = $Sprite2

func _ready():
	var vp = viewport.get_texture()
	sprite.texture = vp
