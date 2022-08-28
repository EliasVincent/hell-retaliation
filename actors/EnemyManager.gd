extends Node2D

onready var enemyHit = $EnemyHit
onready var healthBar : ProgressBar
onready var animationPlayer = get_parent().get_node("AnimationPlayer")

export (float) var hp = 10
var canTakeDamage = true
var willDie = true
var initialHp : float

func _ready():
	initialHp = hp
	healthBar = get_parent().get_node("HealthBarContainer/ProgressBar")

func _physics_process(delta):
	healthBar.value = (hp / initialHp) * 100
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
