extends Node
## This will manage spawning XP blobs, make them fly towards the player, 
## then diseappear and add XP points. Then on level up, 
## it will spawn a level up animation and menu.

onready var levelUpDialog : PackedScene = preload("res://actors/leveling/LevelUpDialog.tscn")

func add_xp(xpToGive: float):
	GlobalVariables.endlessPlayerXp += xpToGive

func levelUpPlayer():
	# This will be called when the player levels up.
	# It will spawn a level up animation and menu.
	# It will also update the player's stats.
	GlobalVariables.endlessPlayerLevel += 1
	
	# Spawn level up animation
	
	# Spawn level up menu
	
	# Update xp threshold
	GlobalVariables.update_endless_level_up_threshold()
	
	# Update player stats in the HUD and XP bar

func _process(delta):
	if GlobalVariables.endlessPlayerXp >= GlobalVariables.endlessLevelUpThreshold:
		levelUpPlayer()
	
func _input(event):
	if event.is_action_pressed("give_xp"):
		add_xp(10.0)
