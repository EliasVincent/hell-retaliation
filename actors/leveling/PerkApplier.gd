extends Node
## This will apply perks to the player

onready var player: KinematicBody2D = get_parent()

func _ready():
	pass

func apply_perk(perk):
	# right now we just get strings
	match(perk):
		"INCREASE_MAX_HP":
			GlobalVariables.perks["INCREASE_MAX_HP"] += 1
			player.start_hp += 20 #TODO: Move starthp to global variables for progressbar
		"INCREASE_HP_REGEN":
			GlobalVariables.perks["INCREASE_HP_REGEN"] += 1
			player.update_healing_tickrate_time(player.healing_tickrate_time - 0.2)
		"FASTER_PARRY_TIME":
			GlobalVariables.perks["FASTER_PARRY_TIME"] += 1
		"INCREASE_BULLET_DAMAGE":
			GlobalVariables.perks["INCREASE_BULLET_DAMAGE"] += 1
		_:
			print("ERROR PERK NOT FOUND: ", perk)
