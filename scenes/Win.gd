extends Control

onready var sprite = $Sprite
onready var viewport = $Viewport

func _ready():
	var vp = viewport.get_texture()
	sprite.texture = vp

func _on_Restart_pressed() -> void:
	var params = { show_progress_bar = true }
	Game.change_scene("res://scenes/Level1.tscn", params)


func _on_Menu_pressed() -> void:
	var params = { show_progress_bar = true }
	Game.change_scene("res://scenes/menu/menu.tscn", params)
