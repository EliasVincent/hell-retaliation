extends Control
## This will open up a dialog to select a perk as a level up reward.
## This dialog pauses the game.
## Those perks should be in GlobalVariables
## match the perks to a row with text and so on

onready var animationPlayer: AnimationPlayer = $AnimationPlayer
onready var button1: Button = $DialogContainer/Panel/VBoxContainer/Button1
onready var button2: Button = $DialogContainer/Panel/VBoxContainer/Button2
onready var button3: Button = $DialogContainer/Panel/VBoxContainer/Button3

onready var player: KinematicBody2D = get_tree().get_nodes_in_group("PLAYER")[0]

var perks: Dictionary = GlobalVariables.perks
var perkKeys = perks.keys()
var perkValues = perks.values()

var perk1
var perk2
var perk3

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS # exclude from pause
	show_level_up_dialog()

func show_level_up_dialog():
	pause()
	var perksToInclude : Array = []

	# get perks and check if they can be used

	# loop through perks and check if they can be used
	for i in range(perkKeys.size()):
		if perkValues[i] <= 5:
			perksToInclude.append(perkKeys[i])

	# randomize perks
	perksToInclude.shuffle()
	# select 3 perks
	perk1 = perksToInclude[0]
	perk2 = perksToInclude[1]
	perk3 = perksToInclude[2]
	# insert them into the buttons
	button1.text = GlobalVariables.perkNames[perk1]
	button2.text = GlobalVariables.perkNames[perk2]
	button3.text = GlobalVariables.perkNames[perk3]
	# animation to fade in AUTO
	animationPlayer.play("FADE_IN")

func pause():
	get_tree().paused = true
func close():
	get_tree().paused = false
	queue_free()


func _on_Button1_pressed():
	#TODO: outsource this
	player.apply_perk(perk1)
	get_tree().paused = false
	animationPlayer.play("FADE_OUT_AND_KILL")


func _on_Button2_pressed():
	player.apply_perk(perk2)
	get_tree().paused = false
	animationPlayer.play("FADE_OUT_AND_KILL")


func _on_Button3_pressed():
	player.apply_perk(perk3)
	get_tree().paused = false
	animationPlayer.play("FADE_OUT_AND_KILL")
