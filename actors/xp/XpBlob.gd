extends Node2D


export (float) var moveSpeed = 150.0
export (float) var xpToGive = 10.0


var canGiveXp: bool = true


func _on_Area2D_body_entered(body):
	if body.is_in_group("PLAYER"):
		# just add xp, let the xp manager handle it
		if canGiveXp:
			XpManager.add_xp(xpToGive)
		canGiveXp = false
		# destroy the xp orb
		#TODO: destroy more gracefully
		queue_free()
	pass

# Get player node position
# Move self towards the player
func _process(delta):
	var player: KinematicBody2D = get_tree().get_nodes_in_group("PLAYER")[0]
	var playerPos = player.position
	var selfPos = self.position
	var distance = playerPos.distance_to(selfPos)
	if distance < 10:
		# move towards player
		var direction = playerPos - selfPos
		direction = direction.normalized()
		position += direction * moveSpeed * delta
	else:
		# move towards player eh something else but
		# area collision should handle this
		var direction = playerPos - selfPos
		direction = direction.normalized()
		position += direction * moveSpeed * delta
	pass
