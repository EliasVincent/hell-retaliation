extends KinematicBody2D

export (int) var speed = 200;
export (int) var start_hp : int = 3;
onready var hp := start_hp;
var can_take_damage = true;
onready var animation_player := $AnimationPlayer

export (bool) var clamp_to_window_borders = true;
onready var screen_borders = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
);

func _physics_process(delta):
	# Input
	var velocity := Vector2()
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	velocity = velocity.normalized();
	velocity = move_and_slide(velocity * speed);
	
	# Clamp to screen borders, make sure we're in the window
	if clamp_to_window_borders:
		global_position = Vector2(clamp(global_position.x, 0, screen_borders.x), clamp(global_position.y, 0, screen_borders.y));

# Andere Scripts (wie Bullets) können diese Methode hier aufrufen
# Player ist so lange unverwundbar wie die Animation dauert
# Zum ändern des Cooldowns die Länge von HIT im AnimationPlayer ändern
func take_damage(damage: float):
	if (can_take_damage):
		can_take_damage = false;
		hp -= damage
		animation_player.play("HIT")
	else:
		return

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "HIT":
		can_take_damage = true
		if hp == 0:
			#Game.change_scene("res://ui/GameOver.tscn")
			print("YOU DIED")


func _ready():
	pass
