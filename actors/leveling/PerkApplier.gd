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
		_:
			print("ERROR PERK NOT FOUND: ", perk)
