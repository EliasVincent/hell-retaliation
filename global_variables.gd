extends Node

var playerHP : float;
var stageTimer : float;
var initialStageTime : float = 60;
var loadLastSave = false;

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		# flips the value to true or false when pressed
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))

