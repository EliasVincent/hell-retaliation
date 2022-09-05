extends Control

onready var sprite = $Sprite
onready var viewport = $Viewport


func _ready():
	$Version/GameVersion.text = ProjectSettings.get_setting("application/config/version")
	$Version/GodotVersion.text = "Godot %s" % Engine.get_version_info().string
	# needed for gamepads to work
	$VBoxContainer/PlayButton.grab_focus()
	if OS.has_feature('HTML5'):
		$VBoxContainer/ExitButton.queue_free()
	var vp = viewport.get_texture()
	sprite.texture = vp


func _on_PlayButton_pressed() -> void:
	var params = { show_progress_bar = true }
	GlobalVariables.loadLastSave = false
	Game.change_scene("res://scenes/Level1.tscn", params)


func _on_ExitButton_pressed() -> void:
	# gently shutdown the game
	var transitions = get_node_or_null("/root/Transitions")
	if transitions:
		transitions.fade_in({
			'show_progress_bar': false
		})
		yield(transitions.anim, "animation_finished")
		yield(get_tree().create_timer(0.3), "timeout")
	get_tree().quit()


func _on_Button_pressed():
	var params = { show_progress_bar = true }
	Game.change_scene("res://scenes/Level1.tscn", params)


func _on_ContinueButton_pressed():
	var params = { show_progress_bar = true, loadSave = true }
	GlobalVariables.loadLastSave = true
	Game.change_scene("res://scenes/Level1.tscn", params)

func _on_EndlessButton_pressed():
	var params = { show_progress_bar = true }
	GlobalVariables.loadLastSave = false
	Game.change_scene("res://scenes/EndlessMode.tscn", params)
