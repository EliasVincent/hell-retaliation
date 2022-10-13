extends Node2D

onready var enemyHit = $EnemyHit
onready var healthBar : ProgressBar
onready var animationPlayer = get_parent().get_node("AnimationPlayer")
onready var xpBlob : PackedScene = preload("res://actors/xp/XpBlob.tscn")
onready var parent : Node2D = get_parent()

onready var movementCooldown : Timer = $MovementCooldown
onready var movementDuration : Timer = $MovementDuration

export (float) var movementSpeed = 50
export (float) var movementDurationTime = 1
export (float) var movementCooldownTime = 1

export (float) var hp = 10
var canTakeDamage = true
var willDie = true
var initialHp : float

# you can disable movement entirely
var isMovementEnabled : bool = true

var isMovementActive : bool = false
var isMoving : bool = false
var movementStartPosition : Vector2
var movementEndPosition : Vector2

func activate_movement(_movementSpeed: float, _movementDurationTime: float, _movementCooldownTime: float):
	isMovementActive = true
	movementDuration.wait_time = _movementDurationTime
	movementCooldown.wait_time = _movementCooldownTime
	movementCooldown.start()


func _ready():
	initialHp = hp
	healthBar = get_parent().get_node("HealthBarContainer/ProgressBar")

	movementStartPosition = parent.position
	activate_movement(movementSpeed, movementDurationTime, movementCooldownTime)

func _physics_process(delta):
	healthBar.value = (hp / initialHp) * 100
	if hp <= 0:
		if willDie:
			die()
	
	# Movement
	if isMovementEnabled and isMovementActive and isMoving:
		# move parent position start to end position within the movementDurationTime

		var direction = movementEndPosition - parent.position
		parent.position += direction.normalized() * movementSpeed * delta	
				

func take_damage(damage: float):
	hp -= damage
	enemyHit.play()
	print("Enemy HP: ", hp)
	print("RECIEVED DAMAGE: ", damage)

func die(timeout: bool = false):
	willDie = false
	# EnemyManager has to be direct Child of Enemy Node
	GlobalSounds.enemyDeathSound.play()
	get_parent().can_fire = false
	if not timeout:
		spawn_xp_blob()
	animationPlayer.play("DIE")

func spawn_xp_blob():
	var blob = xpBlob.instance()
	get_parent().get_parent().add_child(blob)
	blob.position = get_parent().position

func remove_enemy():
	get_parent().queue_free()

func set_movement_goal_position():
	movementEndPosition = Vector2(rand_range(256, get_viewport_rect().size.x - 256), rand_range(80, get_viewport_rect().size.y - 80))
	# wenn start und end position zu nah beieinander sind, dann setze neue end position
	if movementStartPosition.distance_to(movementEndPosition) < 10:
		set_movement_goal_position()


func _on_Area2D_area_entered(area):
	if area.is_in_group("PARRYBULLET"):
		#TODO: maybe different bullets do different damage?
		take_damage(GlobalVariables.parryBulletDamage)
		area.queue_free()


func _on_MovementCooldown_timeout():
	set_movement_goal_position()
	isMoving = true
	movementDuration.start()
	


func _on_MovementDuration_timeout():
	isMoving = false
	movementStartPosition = parent.position
	movementCooldown.start()
