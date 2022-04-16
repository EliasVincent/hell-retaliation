extends KinematicBody2D

export (int) var speed = 200;
export (int) var start_hp : int = 100;
onready var hp = start_hp;
var can_take_damage = true;
onready var animation_player = $AnimationPlayer
onready var player_sprite = $Sprite

export (bool) var clamp_to_window_borders = true;
onready var screen_borders = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
);

enum ColorState {
	BLACK,
	WHITE
}
onready var color_state = ColorState.BLACK;

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
	
	# ColorState
	if Input.is_action_just_pressed("change_color"):
		if color_state == ColorState.BLACK:
			if can_take_damage:
				color_state = ColorState.WHITE;
				animation_player.play("WHITE");
		else:
			if can_take_damage:
				color_state = ColorState.BLACK;
				animation_player.play("BLACK");
	
	
# Andere Scripts (wie Bullets) können diese Methode hier aufrufen
# Player ist so lange unverwundbar wie die Animation dauert
# Zum ändern des Cooldowns die Länge von HIT im AnimationPlayer ändern
func take_damage(damage: float):
	print('damage', can_take_damage)
	if (can_take_damage):
		can_take_damage = false;
		GlobalVariables.playerHP -= damage
		if color_state == ColorState.BLACK:
			animation_player.play("HIT_BLACK");
		else:
			animation_player.play("HIT_WHITE");

func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "HIT_BLACK" or anim_name == "HIT_WHITE":
		can_take_damage = true
		if GlobalVariables.playerHP == 0:
			#Game.change_scene("res://ui/GameOver.tscn")
			print("YOU DIED")

func get_color_state():
	return color_state;

func _ready():
	if color_state == ColorState.BLACK:
		color_state = ColorState.WHITE;
		animation_player.play("WHITE");
	else:
		color_state = ColorState.BLACK;
		animation_player.play("BLACK");
	
	GlobalVariables.playerHP = start_hp
