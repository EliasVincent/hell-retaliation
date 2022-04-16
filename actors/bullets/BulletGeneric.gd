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

enum ColorState {
	BLACK,
	WHITE
}
onready var color_state;

func _ready():
	#$Timer.start(lifetime)
	# if timer too high. could be cool idea tho
	pass

func init():
	if bulletColor == "BLACK":
		sprite.hide()
		blackSprite.show()
		color_state = ColorState.BLACK
	else:
		sprite.show()
		blackSprite.hide()
		color_state = ColorState.WHITE

func _process(delta):
	# either use velocity or rotation
	if use_velocity:
		position += velocity.normalized() * speed * delta
	else:
		# gets rotation from the Area2D Node, in RAD
		position += Vector2(cos(rotation), -sin(rotation)) * speed * delta
	# super fancy spiral effect
	rotation_degrees += rotation_change * delta
	

func _on_VisibilityNotifier2D_screen_exited():
	queue_free()


func _on_BulletGeneric_body_entered(body):
	# Body identifizieren geht auch mit is_in_group oder has_method
	if body.name == "Player":
		if body.get_color_state() == color_state:
			pass
		else:
			body.take_damage(25.0); # siehe Player Skript
