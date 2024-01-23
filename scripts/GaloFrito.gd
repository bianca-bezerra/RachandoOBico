extends CharacterBody2D

#Motion
@export var speed = 300
@export var jump_force = 600
var gravity = 20

#Animation
@onready var animation = $AnimatedSprite2D

#Combate System
var in_attack_range = false
var attack_cooldown = true
var health = 100
var is_alive = true
var damage_rate = 20

	
func  _physics_process(delta):
	player_movement()
	if health <= 0:
		is_alive = false
		health = 0
		print("MORREU")
		self.queue_free()
	enemy_attack()
	
func player():
	pass
	
func player_movement():
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
			
	if Input.is_action_just_pressed("jump"):
		velocity.y = -jump_force
	
	var horizontal_direction = Input.get_axis("move_left","move_right")
	
	velocity.x = horizontal_direction * speed
	
	if velocity.length() > 0:
		animation.play("walk")
	else:
		animation.play("idle")
	
	if velocity.x > 0:
		animation.flip_h = false
	else:
		animation.flip_h = true
	move_and_slide()
	
func _on_hitbox_player_body_entered(body):
	if body.has_method("enemy"):
		in_attack_range = true
		
func _on_hitbox_player_body_exited(body):
	if body.has_method("enemy"):
		in_attack_range = false

func enemy_attack():
	if in_attack_range == true and attack_cooldown == true:
		health -= damage_rate
		print("Levando dano")
		attack_cooldown = false
		$AttackCoolDown.start()
	
func _on_attack_cool_down_timeout():
	attack_cooldown = true
