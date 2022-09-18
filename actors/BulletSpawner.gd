extends Node2D

# All Enemies need:
# - Main Node attached to this Script and assigned to Group "ENEMY" 
# in order to make the StageManager recognize it
# - Sprite
# - Timer
# - Area2D's area_entered Connected to EnemyManager
# - EnemyManager
# - AnimationPlayer with a "DIE" Animation

export (PackedScene) var bullet_scene: PackedScene;
export var min_rotation = 0;
export var max_rotation = 360;
export var number_of_bullets = 8;
export (bool) var is_random = false;
#export (bool) var is_manual = false;
export (float) var spawn_rate = 0.4;
export (float) var bullet_speed = 5;
export (Vector2) var bullet_velocity = Vector2(1,0);
export (bool) var use_velocity = false; # If false use rotation

export (bool) var changeColorAfterShot = false;
export (String) var bulletColor = "A";

# access rotation of Bullets themselves
export (float) var bulletRotationChange = 0
# super fancy spiral effect ON THE SPAWNER
export (float) var spawnerRotationChange = 0

# change rotation after each shot
export (float) var rotationChangeAfterTick = 0

# change size of bullets
export (bool) var changeBulletSize = false
# Scale Vector2 of Bullet Size (default: 0.5,0.5)
export (Vector2) var bulletScaleVector = Vector2(0.25,0.25)

var rotations = [];
export (bool) var log_to_console;

export var can_fire = true

onready var animation_player = $AnimationPlayer
onready var enemy_manager = $EnemyManager

func _ready():
	$Timer.wait_time = spawn_rate
	$Timer.start()

func _process(delta):
	rotation_degrees += spawnerRotationChange * delta

func random_rotations():
	rotations = [];
	for _i in range(0, number_of_bullets):
		rotations.append(rand_range(min_rotation, max_rotation));

func distributed_rotations():
	rotations = [];
	for i in range(0, number_of_bullets):
		# evenly distributed
		var fraction = float(i) / float(number_of_bullets);
		var difference = max_rotation - min_rotation;
		rotations.append((fraction * difference) + min_rotation);

func spawn_bullets():
	#Change rotation after each shot IF ENABLED
	min_rotation -= rotationChangeAfterTick
	max_rotation -= rotationChangeAfterTick
	
	#Change color after each shot IF ENABLED
	if (changeColorAfterShot):
		if (bulletColor == "A"):
			bulletColor = "B"
		else:
			bulletColor = "A"
	
	if (is_random):
		random_rotations();
	else:
		distributed_rotations();
	
	animation_player.play("EMIT")
	
	var spawned_bullets = [];
	for i in range(0, number_of_bullets):
		# Instancing
		var bullet = bullet_scene.instance();
		
		spawned_bullets.append(bullet);
		
		# Parenting
		# Bullets sind keine Children sondern ein Node unter dem Spawner
		# Heißt alle Nodes unter dem Spawner werden über den Bullets gerendert
		get_parent().add_child_below_node(self, spawned_bullets[i]);
		
		# Apply Fields
		# rotation_degress from spawnerRotationChange
		spawned_bullets[i].rotation_degrees = rotations[i] + rotation_degrees;
		spawned_bullets[i].speed = bullet_speed;
		spawned_bullets[i].velocity = bullet_velocity;
		spawned_bullets[i].global_position = global_position;
		spawned_bullets[i].use_velocity = use_velocity;
		spawned_bullets[i].rotation_change = bulletRotationChange;
		spawned_bullets[i].spawner = self;
		spawned_bullets[i].bulletColor = bulletColor;
		# _ready() does not work for the color
		if (changeBulletSize):
			spawned_bullets[i].global_scale = bulletScaleVector
		spawned_bullets[i].init();
		
		if (log_to_console):
			print("Bullet " + str(i) + " @ " + str(rotations[i]) + "deg");
	
	return spawned_bullets;

# call die() in the enemy manager
func call_timeout_die():
	enemy_manager.die(true)


func _on_Timer_timeout():
#	if !is_manual:
#		spawn_bullets();
	if can_fire:
		spawn_bullets();
	
	if (log_to_console):
		print("Spawned Bullets")


func _on_Area2D_area_entered(area):
	pass # Replace with function body.
