extends CharacterBody2D

#Bullet Hell
const bullet_scene = preload("res://bala.tscn")
@onready var shoot_timer = $ShootTimer
@onready var rotater = $Rotater

const rotate_speed = 30
const shoot_timer_wait_time = 1.5
const spawn_point_count = 10
const radius = 20

#Nodes
@onready var animation = $sprite
@onready var ground_detector = $ground_detector
@onready var fireball_spawn_point = $fireball_spawn_point
@onready var sprite = $sprite
@onready var cooldown_fireball = $cooldown_fireball
const DEATH = preload("res://scenes/death.tscn");
@onready var shoot_sfx = $shoot_sfx
@onready var hurt_sfx = $hurt_sfx as AudioStreamPlayer

#Motion
const RIGHT = 1;
const LEFT = -1;
var direction := RIGHT;
@export var move_speed := 50;
#var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")

#Combat System
const FIREBALL = preload("res://scenes/fireball.tscn");
@export var health_points := 1;
var can_shoot = true;
var damage_rate = 1
enum EnemyState {PATROL, ATTACK, HURT, DEATH}
var current_state := EnemyState.PATROL;

#Player
@export var target : CharacterBody2D

#Functions #####################################################################
func _ready():	
	var step = 2 * PI / spawn_point_count
	
	for i in range(spawn_point_count):
		var spawn_point = Node2D.new()
		var pos = Vector2(radius, 0).rotated(step * i)
		spawn_point.position = pos
		spawn_point.rotation = pos.angle()
		rotater.add_child(spawn_point)
		
	shoot_timer.wait_time = shoot_timer_wait_time
	shoot_timer.start()

func _physics_process(delta):
	var new_rotation = rotater.rotation_degrees + rotate_speed * delta
	rotater.rotation_degrees = fmod(new_rotation, 360)
	
	#if !is_on_floor():
	#	velocity.y += gravity * delta
	match(current_state):
		EnemyState.PATROL : patrol_state();
		EnemyState.ATTACK : attack_state();
		EnemyState.DEATH : queue_free();

func patrulha():
	pass

#Direction
func flip_enemy():
	direction *= -1;
	animation.flip_h = take_dir();
	fireball_spawn_point.position.x *= -1;

func take_dir():
	if direction == RIGHT:
		return false  ;
	elif direction == LEFT:
		return true;

#Attack ########################################################################
func spawn_fireball():

	var new_fireball = FIREBALL.instantiate();
	const BOMB = 4;
	if sign(fireball_spawn_point.position.x) == RIGHT:
		new_fireball.set_direction(RIGHT, BOMB);
	else:
		new_fireball.set_direction(LEFT, BOMB);

	add_sibling(new_fireball);
	shoot_sfx.global_position = fireball_spawn_point.global_position;
	shoot_sfx.play();
	new_fireball.global_position = fireball_spawn_point.global_position;

#Triggers ######################################################################
func _on_cooldown_fireball_timeout():
	can_shoot = true;

func _on_hitbox_body_entered(body):
	if body.has_method("ovo"):
		hurt_state();
	#if body.has_method("player"):
		#body.fireball_attack();
	#change_state(EnemyState.HURT);
	#player_inattack_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("ovo"):
		hurt_state();
	#if body.has_method("player"):
		#body.fireball_attack();
	#if body.has_method("ovo"):
		#player_inattack_range = false

func _on_detection_area_body_entered(body):
	if(body.has_method("player")):
		change_to_attack_state();

func _on_detection_area_body_exited(body):
	if(body.has_method("player")):
		change_state(EnemyState.PATROL);

#State Machine #################################################################
func change_state(state : EnemyState):
	current_state = state;

func patrol_state():
	animation.play("walk")
	if is_on_wall() or not ground_detector.is_colliding():#batendo numa parede ou chegando num buraco
		flip_enemy();
	velocity.x = move_speed * direction;
	move_and_slide();

func hurt_state():

	if(health_points == 0):
		global.level3_completed = true
		print("No céu tem milho?");
		var death = DEATH.instantiate();
		add_sibling(death);
		death.global_position = $death_point.global_position;
		death.play("default");
		change_state(EnemyState.DEATH);

	else:
		hurt_sfx.global_popsition = $death_point.global_position;
		hurt_sfx.play();
		play_hurt_anim();
		print("Patrulheira: Ai!")
		health_points -= 1;
		current_state = EnemyState.PATROL;

func attack_state():

	print("Jogador detectado!");
	animation.flip_h = take_dir();
	animation.play("angry")
	await get_tree().create_timer(0.3).timeout;
	if(can_shoot):
		spawn_fireball();
		can_shoot = false;
		cooldown_fireball.start();
		print("Fireball lançada!")

func get_player_direction():
	if target.position.x > position.x:
		return RIGHT;
	return LEFT;

func change_to_attack_state():

	if (get_player_direction() == RIGHT and direction == LEFT) or (get_player_direction() == LEFT and direction == RIGHT):
		flip_enemy();

	change_state(EnemyState.ATTACK);

#Animations ####################################################################
func play_hurt_anim():

	$hit.visible = true;
	$hit.flip_h = take_dir();
	$hit.play("default");
	$sprite.visible = false;
	$hurt.visible = true;
	$sprite.flip_h = take_dir();
	$hurt.play("default");
	await get_tree().create_timer(0.3).timeout;
	$hurt.visible = false;
	$hit.visible = false;
	$sprite.visible=true;


func _on_shoot_timer_timeout():
	for s in rotater.get_children():
		var bullet = bullet_scene.instantiate()
		get_tree().root.add_child(bullet)
		bullet.position = s.global_position
		bullet.rotation = s.global_rotation	
