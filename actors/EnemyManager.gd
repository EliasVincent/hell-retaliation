extends Node2D

onready var enemyHit = $EnemyHit

export (float) var hp = 10
var canTakeDamage = true

func _ready():
	pass

func _process(delta):
	if hp <= 0:
		die()

func take_damage(damage: float):
	hp -= damage
	enemyHit.play()
	print("Enemy HP: ", hp)

func die():
	# EnemyManager has to be direct Child of Enemy Node
	GlobalSounds.enemyDeathSound.play()
	get_parent().can_fire = false
	get_parent().queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("PARRYBULLET"):
		# maybe different bullets do different damage?
		take_damage(1)
		area.queue_free()
