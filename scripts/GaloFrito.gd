extends CharacterBody2D

#Motion
@export var speed = 300
@export var jump_force = -300
@export var double_jump_force : float = -300;
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_direction = "none"
var has_double_jumped : bool = false;

#Animation
@onready var animation = $AnimatedSprite2D

#Combat System
@onready var BULLET = preload("res://ovo.tscn")
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 10
var knockback_vector := Vector2.ZERO
var is_alive = true
var damage_rate = 1
var attack_ip = false
var is_ondamage = false

	
func  _physics_process(delta):
		
	player_movement(delta)
	attack()
	enemy_attack()
	attack()
	
	
func play_animation(movement):
	var dir = current_direction
	var animation = $AnimatedSprite2D
	
	if !is_on_floor():
		if attack_ip == false:
			if dir == "right":
				animation.flip_h = false
			elif dir == "left":
				animation.flip_h = true
			animation.play("jump")
			
	elif dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("idle")
			
	elif dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("idle")
	

func player():
	pass
	
func player_movement(delta):
	
	if !is_on_floor():
		velocity.y += gravity * delta
		if velocity.y > 1000:
			velocity.y = 1000
	else:
		has_double_jumped = false;
			
	if Input.is_action_just_pressed("ui_accept"):
		if is_on_floor() == true:
			velocity.y = jump_force
		elif not has_double_jumped:
			velocity.y = double_jump_force;
			has_double_jumped = false;

	elif Input.is_action_pressed("ui_right"):
		current_direction = "right"
		play_animation(1)
		velocity.x = speed
		
	elif Input.is_action_pressed("ui_left"):
		current_direction = "left"
		play_animation(1)
		velocity.x = -speed
	
	else:
		play_animation(0)
		velocity.x = 0
	
	if knockback_vector != Vector2.ZERO:
		velocity = knockback_vector
		
	move_and_slide()
	
func _on_hitbox_player_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
		
func _on_hitbox_player_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range == true and enemy_attack_cooldown == true:
		
		if health <= 0:
			is_alive = false
			health = 0
			self.queue_free()
			get_tree().change_scene_to_file("res://screens/scenes/game_over.tscn")
		else:
			animation.play("take_damage")
			if $RayRight.is_colliding() or $Ray2.is_colliding() or $Ray3.is_colliding():
				take_damage(Vector2(-1000,-400))
			elif $RayLeft.is_colliding() or $Ray1.is_colliding() or $Ray4.is_colliding():
				take_damage(Vector2(1000,-400))
			elif $RayUp.is_colliding():
				take_damage(Vector2(400,0))
			elif $RayDown.is_colliding():
				take_damage(Vector2(0,-1000))
		
		enemy_attack_cooldown = false
		$AttackCoolDown.start()
		
func _on_attack_cool_down_timeout():
	enemy_attack_cooldown = true

func attack():
	var dir = current_direction
	if Input.is_action_just_pressed("attack"):
		global.player_current_attack = true
		attack_ip = true
		if dir == "right" or dir == "none":
			animation.flip_h = false
			animation.play("attack")
			
			$AttackDeal.start()
		if dir == "left":
			animation.flip_h = true
			animation.play("attack")
			
			$AttackDeal.start()
		shoot()
func _on_attack_deal_timeout():
	$AttackDeal.stop()
	global.player_current_attack = false
	attack_ip = false

func take_damage(knoback_force := Vector2.ZERO,duration := 0.15):
	is_ondamage = true
	health -= damage_rate
	if knoback_force != Vector2.ZERO:
		knockback_vector = knoback_force
		var knoback_tween = get_tree().create_tween()
		knoback_tween.tween_property(self, "knockback_vector", Vector2.ZERO, duration)

func shoot():
	var new_bullet = BULLET.instantiate()
	$Marker2D.add_child(new_bullet)
	new_bullet.global_position = global_position
	new_bullet.global_rotation = global_rotation

