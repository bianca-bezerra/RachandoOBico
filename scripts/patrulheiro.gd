extends CharacterBody2D

#Nodes
@onready var animation = $sprite
@onready var ground_detector = $ground_detector
@onready var fireball_spawn_point = $fireball_spawn_point
@onready var sprite = $sprite
@onready var cooldown_fireball = $cooldown_fireball

#Motion
const RIGHT = 1;
const LEFT = -1;
var direction := RIGHT;
@export var move_speed := 50;


#Combat System
const FIREBALL = preload("res://scenes/fireball.tscn");
var player_inattack_range = false
var can_take_damage = true
@export var health_points := 5;
var can_shoot = true;
var damage_rate = 1
enum EnemyState {PATROL, ATTACK, HURT}
var current_state := EnemyState.PATROL;

#Player
@export var target : CharacterBody2D
	
#Functions #####################################################################
func _ready():
	animation.flip_h = true;

func _physics_process(delta):
	match(current_state):
		EnemyState.PATROL : patrol_state();
		EnemyState.ATTACK : attack_state();
		
func enemy():
	pass

#Direction
func flip_enemy():
	direction *= -1;
	animation.flip_h = take_dir();
	fireball_spawn_point.position.x *= -1;
	
func take_dir():
	
	if direction == RIGHT:
		return true  ;
	elif direction == LEFT:
		return false;

#Attack ########################################################################
func spawn_fireball():
	
	var new_fireball = FIREBALL.instantiate();
	if sign(fireball_spawn_point.position.x) == RIGHT:
		new_fireball.set_direction(RIGHT);
	else:
		new_fireball.set_direction(LEFT);
		
	add_sibling(new_fireball);
	new_fireball.global_position = fireball_spawn_point.global_position;
	

#Triggers ######################################################################
func _on_cooldown_fireball_timeout():
	can_shoot = true;

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		_change_state(EnemyState.HURT);
		player_inattack_range = true
		hurt_state();
	

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false

func _on_detection_area_body_entered(body):
	if(body.has_method("player")):
		change_to_attack_state();

func _on_detection_area_body_exited(body):
	if(body.has_method("player")):
		_change_state(EnemyState.PATROL);

	
#State Machine #################################################################
func _change_state(state : EnemyState):
	current_state = state;
	
func patrol_state():
	animation.play("side_walk")
	if is_on_wall() or not ground_detector.is_colliding():#batendo numa parede ou chegando num buraco
		flip_enemy();
	velocity.x = move_speed * direction;		
	move_and_slide();

func hurt_state():
	
	if(health_points == 0):
		$sprite.play("death")
		await get_tree().create_timer(1).timeout;
		print("No céu tem milho?");
		queue_free();
	
	play_hurt_anim();
	print("Patrulheira: Ai!")
	health_points -= 1;
	current_state = EnemyState.PATROL;

func attack_state():
	
	print("Jogador detectado!");
	
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

	$exclamation.visible = true;
	_change_state(EnemyState.ATTACK);			
	$exclamation.flip_h = take_dir();
	$exclamation.play("default");
	await get_tree().create_timer(0.3).timeout;	
	$exclamation.visible=false;

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
