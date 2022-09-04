extends KinematicBody2D
# requires Node in group CAMERA to work
export (float) var parry_cooldown = 0.1 #Cooldown after Parry Button was pressed
export (int) var speed = 200;
export (int) var start_hp : int = 100;
onready var hp = start_hp;
var can_take_damage = true;
onready var animation_player = $AnimationPlayer
onready var player_sprite = $Sprite
onready var parry_area = $ParryArea
onready var parry_cooldown_timer = $ParryCooldownTimer
onready var flySoundDelay = $FlySoundDelay

onready var player_hit_sound = $Sfx/PlayerHit
onready var player_death_sound = $Sfx/PlayerDeath
onready var parry_zero_sound = $Sfx/ParryZero
onready var parry_success_sound = $Sfx/ParrySuccess
onready var parry_gone_sound = $Sfx/ParryGone
onready var bullet_fly_sound = $Sfx/BulletFly
onready var color_switch_sound = $Sfx/ColorSwitch

onready var debug_label = $Label
onready var parry_bullet : PackedScene = preload("res://actors/bullets/ParryBullet.tscn")
var can_parry = true

export (bool) var clamp_to_window_borders = true;
onready var screen_borders = Vector2(
	ProjectSettings.get_setting("display/window/size/width"),
	ProjectSettings.get_setting("display/window/size/height")
);

enum ColorState {
	B,
	A
}
onready var color_state = ColorState.B;

onready var parryable_bullets = []
onready var bullets_to_add = []
var parry_rotations = [];
var max_rotation = 360
var min_rotation = 0

# params for parry bullet
var parry_bullet_rotation_degrees = 30 # rotate per parry
var parry_bullet_speed = 200
export (float) var spawn_rate = 0.4;
export (Vector2) var bullet_velocity = Vector2(1,0);
export (bool) var use_velocity = false; # If false use rotation, If true use velocity
# access rotation of Bullets themselves
export (float) var bulletRotationChange = 0
var bulletColor = "A";

# crouch / slow mode
var is_crouching = false
export (float) var crouch_speed = speed / 2

onready var camera : Camera2D = get_tree().get_nodes_in_group("CAMERA")[0]
onready var screenShake : Node = camera.get_node("ScreenShake")

export (float) var damage_cooldown = 0.9
onready var damage_cooldown_timer = $DamageCooldown

func _physics_process(delta):
	# Input
	var velocity := Vector2()
	velocity.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	velocity.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up");
	velocity = velocity.normalized();
	if is_crouching:
		velocity = move_and_slide(velocity * crouch_speed);
	else:
		velocity = move_and_slide(velocity * speed);
	
	# ColorState
	if Input.is_action_just_pressed("change_color"):
		color_switch_sound.play()
		if color_state == ColorState.B:
			color_state = ColorState.A;
			animation_player.play("A");
		else:
			color_state = ColorState.B;
			animation_player.play("B");
	
	# Parry
	if Input.is_action_just_pressed("parry"):
		if can_parry:
			can_parry = false
			parry_cooldown_timer.start(parry_cooldown);
			parry(parryable_bullets);
	
	if can_parry:
		debug_label.text = str("READY")
	if not can_parry:
		debug_label.text = str("COOLDOWN")
	
	# Crouch / Slow mode
	if Input.is_action_pressed("crouch"):
		is_crouching = true
	else:
		is_crouching = false

func _process(delta):
	# Clamp to screen borders, make sure we're in the window
	if clamp_to_window_borders:
		global_position = Vector2(clamp(global_position.x, 0, screen_borders.x), clamp(global_position.y, 0, screen_borders.y));
	if GlobalVariables.playerHP == 0:
		Game.change_scene("res://scenes/GameOver.tscn")
# Andere Scripts (wie Bullets) können diese Methode hier aufrufen
# Player ist so lange unverwundbar wie die Animation dauert
# Zum ändern des Cooldowns die Länge von HIT im AnimationPlayer ändern
func take_damage(damage: float):
	#print('damage', can_take_damage)
	if (can_take_damage):
		can_take_damage = false;
		damage_cooldown_timer.start(damage_cooldown)
		GlobalVariables.playerHP -= damage
		player_hit_sound.play()
		screenShake.start(0.1, 15, 4, 0)
		if color_state == ColorState.B:
			animation_player.play("HIT_B");
		else:
			animation_player.play("HIT_A");


# PARRY STUFF OH LAWD
func parry(bullets: Array):
	bullets_to_add += bullets;
	instance_parry_bullet(bullets_to_add);
	
	parry_bullet_rotation_degrees += 30;
	bullets_to_add = [];
	
	for bullet in bullets:
		# kann auch ne Animation sein wie sie verschwinden
		bullet.queue_free()
	
	if bullets.size() == 0:
		parry_zero_sound.play()
	
	if bullets.size() > 0:
		parry_success_sound.play()
		var soundDelayTime = 2.0
		flySoundDelay.start(soundDelayTime)
	
func distributed_rotations(bulletArray):
	parry_rotations = [];
	for i in range(0, bulletArray.size()):
		# evenly distributed
		var fraction = float(i) / float(bulletArray.size());
		var difference = max_rotation - min_rotation;
		parry_rotations.append((fraction * difference) + min_rotation);

func instance_parry_bullet(bulletArray):
	distributed_rotations(bulletArray);
	var spawned_bullets = [];
	for i in range(0, bulletArray.size()):

		var instance = parry_bullet.instance();
		spawned_bullets.append(instance);
		add_child(instance);

		spawned_bullets[i].rotation_degrees = parry_rotations[i] + parry_bullet_rotation_degrees;
		spawned_bullets[i].speed = parry_bullet_speed;
		spawned_bullets[i].velocity = bullet_velocity;
		spawned_bullets[i].global_position = global_position;
		spawned_bullets[i].use_velocity = use_velocity;
		spawned_bullets[i].rotation_change = bulletRotationChange;
		
		spawned_bullets[i].spawner = bulletArray[i].get_spawner();
		
		
		spawned_bullets[i].color_state = color_state;
		print("Player ColorState: ", color_state)
		# _ready() does not work for the color
		spawned_bullets[i].init();



func _on_AnimationPlayer_animation_finished(anim_name):
	pass
#	if anim_name == "HIT_B" or anim_name == "HIT_A":
#		can_take_damage = true
#		if GlobalVariables.playerHP == 0:
#			Game.change_scene("res://scenes/GameOver.tscn")

func get_color_state():
	return color_state;


func _ready():
	if color_state == ColorState.B:
		color_state = ColorState.A;
		animation_player.play("A");
	else:
		color_state = ColorState.B;
		animation_player.play("B");
	
	GlobalVariables.playerHP = start_hp


func _on_ParryArea_area_entered(area):
	if area.is_in_group("BULLET"):
		if area.color_state == color_state:
			# if it's the same color:
			parryable_bullets.append(area)
			#print("parryable_bullets", parryable_bullets)

func _on_ParryArea_area_exited(area):
	if area.is_in_group("BULLET"):
		parryable_bullets.erase(area)
		#print("parryable_bullets", parryable_bullets)


func _on_ParryCooldownTimer_timeout():
	can_parry = true

func change_to_game_over():
	Game.change_scene("res://scenes/GameOver.tscn")
	


func _on_FlySoundDelay_timeout():
	print("timeout")
	bullet_fly_sound.play()


func _on_DamageCooldown_timeout():
	can_take_damage = true


func _on_HealingTickrate_timeout():
	if GlobalVariables.playerHP < 92:
		GlobalVariables.playerHP += 2
