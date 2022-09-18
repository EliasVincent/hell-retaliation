extends Node

var playerHP : float;
var stageTimer : float;
var initialStageTime : float = 60;
var loadLastSave = false;

# XP player has in endless mode
var endlessPlayerXp: float = 0.0;
var endlessPlayerLevel: int = 1;
var initialEndlessLevelUpThreshold: float = 100.0;
var endlessLevelUpMultiplier: float = 1.6;
var endlessLevelUpThreshold: float = 100.0;
var endlessLevelUpPrevThreshold: float = 0.0;

# Perks Array
var perks: Dictionary = {
	"INCREASE_MAX_HP" : 0,
	"INCREASE_HP_REGEN": 0,
	"FASTER_PARRY_TIME": 0,
}

var perkNames: Dictionary = {
	"INCREASE_MAX_HP" : "Increase Max HP",
	"INCREASE_HP_REGEN": "Increase HP Regen",
	"FASTER_PARRY_TIME": "Faster Parry Time",
}

func _ready():
	endlessLevelUpThreshold = initialEndlessLevelUpThreshold

func _process(delta):
	if Input.is_action_just_pressed("fullscreen"):
		# flips the value to true or false when pressed
		OS.window_fullscreen = !OS.window_fullscreen
	if Input.is_action_just_pressed("mute"):
		AudioServer.set_bus_mute(0, not AudioServer.is_bus_mute(0))


func update_endless_level_up_threshold():
	endlessLevelUpPrevThreshold = endlessLevelUpThreshold
	endlessLevelUpThreshold *= endlessLevelUpMultiplier
