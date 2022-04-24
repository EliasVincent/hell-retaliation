extends Control

onready var progressBar = $ProgressBar

func _process(delta):
	progressBar.value = GlobalVariables.playerHP
	

func _ready():
	pass
