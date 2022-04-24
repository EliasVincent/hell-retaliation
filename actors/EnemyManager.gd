extends Node2D

onready var enemyHit = $EnemyHit
onready var animationPlayer = get_parent().get_node("AnimationPlayer")

export (float) var hp = 10
var canTakeDamage = true
var willDie = true

func _ready():
	#nothing
	pass

func _physics_process(delta):
	if hp <= 0:
		if willDie:
			die()

func take_damage(damage: float):
	hp -= damage
	enemyHit.play()
	print("Enemy HP: ", hp)

func die():
	willDie = false
	# EnemyManager has to be direct Child of Enemy Node
	GlobalSounds.enemyDeathSound.play()
	get_parent().can_fire = false
	animationPlayer.play("DIE")

func remove_enemy():
	get_parent().queue_free()

func _on_Area2D_area_entered(area):
	if area.is_in_group("PARRYBULLET"):
		# maybe different bullets do different damage?
		take_damage(1)
		area.queue_free()
