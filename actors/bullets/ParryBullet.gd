extends Area2D

export (float) var speed = 400
export (float) var time = 4.0
export (float) var initTime = 0.2
onready var timer = $Timer
onready var initTimer = $InitTimer

export (Vector2) var velocity = Vector2()
export (bool) var use_velocity
#export (float) var rotation_change
var rotation_change = 0.0
export (String) var bulletColor

var isIniting = true

func _ready():
	print("I'm instanced!")
	timer.start(time)
	initTimer.start(initTime)
	#TODO: set velocity and make it fly for a short while to have it actually around the player and not dead on him

func init():
	pass


func _process(delta):
	# either use velocity or rotation
	if use_velocity:
		position += velocity.normalized() * speed * delta
	else:
		if isIniting:
			position += Vector2(cos(rotation), -sin(rotation)) * speed * delta
		else:
			position += Vector2(0,0)
	# super fancy spiral effect
	rotation_degrees += rotation_change * delta

func fly_toward_enemy():
	print("WEEEEEE")
	hide()

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_Timer_timeout():
	fly_toward_enemy()


func _on_InitTimer_timeout():
	isIniting = false
