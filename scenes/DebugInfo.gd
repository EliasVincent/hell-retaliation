extends Control


func _ready():
	pass

func _process(delta):
	$Label.text = 'FPS: ' + str(Engine.get_frames_per_second())
	$Label2.text = 'Bullets: ' + str(get_tree().get_nodes_in_group("BULLET").size())
	$Label3.text = 'XP: ' + str(GlobalVariables.enldessPlayerXp)
