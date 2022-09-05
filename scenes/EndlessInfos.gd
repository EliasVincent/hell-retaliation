extends Control

func _process(delta):
	$StageLabel.text = "Stage: " + str(get_parent().get_node("EndlessManager").currStageCount)
