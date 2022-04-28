extends Control

onready var progressBar = $ProgressBar
onready var timerProgress = $TimerProgress

var stageTimer : float

func _process(delta):
	progressBar.value = GlobalVariables.playerHP
	stageTimer = GlobalVariables.stageTimer
	# display the stageTimer in a value from 0 to 100 relative to 60
	timerProgress.value = (stageTimer / GlobalVariables.initialStageTime) * 100

