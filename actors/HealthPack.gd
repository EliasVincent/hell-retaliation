extends Node2D


func _ready():
	pass


func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if GlobalVariables.playerHP >= 0:
			GlobalVariables.playerHP += 10
			GlobalSounds.healthPickupSound.play()
			queue_free()
