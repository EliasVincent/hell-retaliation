extends Control

onready var progressBar : ProgressBar = $ProgressBar
onready var timerProgress : ProgressBar = $TimerProgress
onready var xpProgress : ProgressBar = $XpProgress
onready var xpLevelCounter : RichTextLabel = $XpLevelCounter

var stageTimer : float

func _ready():
	self.pause_mode = Node.PAUSE_MODE_PROCESS

func _process(delta):
	progressBar.value = GlobalVariables.playerHP
	stageTimer = GlobalVariables.stageTimer
	# display the stageTimer in a value from 0 to 100 relative to 60
	timerProgress.value = (stageTimer / GlobalVariables.initialStageTime) * 100
	
	# display the xp in a value from 0 to 100 relative to the threshold and previous threshold, like a bar
	xpProgress.value = (GlobalVariables.endlessPlayerXp - GlobalVariables.endlessLevelUpPrevThreshold) / (GlobalVariables.endlessLevelUpThreshold - GlobalVariables.endlessLevelUpPrevThreshold) * 100
	
	xpLevelCounter.text = str(GlobalVariables.endlessPlayerLevel)
