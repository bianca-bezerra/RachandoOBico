extends CharacterBody2D

#Motion
@export var speed = 300
@export var jump_force = 600
var gravity = 20
var current_direction = "none"

#Animation
@onready var animation = $AnimatedSprite2D

#Combat System
var enemy_inattack_range = false
var enemy_attack_cooldown = true
var health = 10000
var is_alive = true
var damage_rate = 20
var attack_ip = false

	
func  _physics_process(delta):
	player_movement()
	attack()
	enemy_attack()
	
	if health <= 0:
		is_alive = false
		health = 0
		print("MORREU")
		self.queue_free()
		
	enemy_attack()
	attack()
	
func play_animation(movement):
	var dir = current_direction
	var animation = $AnimatedSprite2D
	
	if dir == "right":
		animation.flip_h = false
		if movement == 1:
			animation.play("walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("idle")
			
	if dir == "left":
		animation.flip_h = true
		if movement == 1:
			animation.play("walk")
		elif movement == 0:
			if attack_ip == false:
				animation.play("idle")
	if !is_on_floor():
		if attack_ip == false:
			animation.play("fly")

func player():
	pass
	
func player_movement():
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("ui_accept"):
		velocity.y = -jump_force

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
		
	move_and_slide()
	
func _on_hitbox_player_body_entered(body):
	if body.has_method("enemy"):
		enemy_inattack_range = true
		
func _on_hitbox_player_body_exited(body):
	if body.has_method("enemy"):
		enemy_inattack_range = false

func enemy_attack():
	if enemy_inattack_range == true and enemy_attack_cooldown == true:
		health -= damage_rate
		print("Levando dano")
		enemy_attack_cooldown = false
		$AttackCoolDown.start()
		
	print("fritooo HEALTH", health)
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
	
func _on_attack_deal_timeout():
	$AttackDeal.stop()
	global.player_current_attack = false
	attack_ip = false
