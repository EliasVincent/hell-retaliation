extends Area2D

# Bullets Despawnen ist auch mit Timer und lifetime lösbar,
# ist aber wahrscheinlich performance hog.
# Wir nehmen VisibilityNotifier

# Collision Layer 1 und Monitorable ist deaktiviert weil performance
onready var sprite = $Sprite
onready var blackSprite = $BlackSprite

export (float) var speed = 200
#export (float) var lifetime = 10.0
export (Vector2) var velocity = Vector2()
export (bool) var use_velocity
#export (float) var rotation_change
var rotation_change = 0.0
export (String) var bulletColor
var spawner

# how many pixels far is the bullet allowed to be
# off-screen until it disappears?
export var visibilityOffset = 20

enum ColorState {
	B,
	A
}
onready var color_state;

func _ready():
	#$Timer.start(lifetime)
	# if timer too high. could be cool idea tho
	pass

func init():
	if bulletColor == "B":
		sprite.hide()
		blackSprite.show()
		color_state = ColorState.B
	else:
		sprite.show()
		blackSprite.hide()
		color_state = ColorState.A

func _process(delta):
	# own VisibilityNotifier cause the real one is kinda buggy lol
	var insideWindowBorder = global_position.x > 0 - visibilityOffset and global_position.x < Game.size.x + visibilityOffset and global_position.y > 0 - visibilityOffset and global_position.y < Game.size.y + visibilityOffset
	if not insideWindowBorder:
		queue_free()
		

func _physics_process(delta):
	# either use velocity or rotation
	if use_velocity:
		position += velocity.normalized() * speed * delta
	else:
		# gets rotation from the Area2D Node, in RAD
		position += Vector2(cos(rotation), -sin(rotation)) * speed * delta
	# super fancy spiral effect
	rotation_degrees += rotation_change * delta

func get_spawner():
	return spawner

func get_color_state_string():
	if color_state == ColorState.B:
		return "B"
	if color_state == ColorState.A:
		return "A"
	else:
		return "ERROR"

func _on_BulletGeneric_body_entered(body):
	# Body identifizieren geht auch mit is_in_group oder has_method
	if body.name == "Player":
		if body.get_color_state() == color_state:
			pass
		else:
			body.take_damage(5.0); # siehe Player Skript
