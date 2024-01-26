extends CharacterBody2D

#Detection
var attack_mode = false

#Motion
var speed = 90
var gravity = ProjectSettings.get_setting("physics/2d/default_gravity")
var current_direction
var jump_force = 50

#Player
@onready var player = get_node("/root/Level2/GaloFrito")

#Combat System
var health = 0
var damage_rate = 30
var player_inattack_range = false
var can_take_damage = true

@onready var animation = $AnimatedSprite2D

func _physics_process(delta):
	
	if is_on_floor():
		velocity.y = jump_force;

	if !is_on_floor():
		velocity.y += gravity * delta
		
	var target = player
	var direction = (target.position - position).normalized()

	if attack_mode:
		
		velocity.x = direction.x * speed

		if velocity.length() > 0.0:
			if velocity.x > 0.0:
				
				current_direction = "right"
				animation.flip_h = true  
				animation.play("walk")
				
			elif velocity.x < 0.0:
				
				current_direction = "left"
				animation.flip_h = false 
				animation.play("walk")
	else:
		velocity.x = 0
		animation.play("idle")
	
	take_damage()
	move_and_slide()

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		attack_mode = true
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		attack_mode = false

func enemy():
	pass

func _on_hitbox_body_entered(body):
	if body.has_method("player"):
		player_inattack_range = true

func _on_hitbox_body_exited(body):
	if body.has_method("player"):
		player_inattack_range = false

func take_damage():

	if player_inattack_range == true and global.player_current_attack == true:
		
		if can_take_damage == true:
			health -= damage_rate
			print("tomei dano")
			$TakeDamageCoolDown.start()
			can_take_damage = false
			
			if health <= 0:
				set_physics_process(false)
				$AnimatedSprite2D.play("death")
				$Timer.start()
				global.level2_completed = true

func _on_take_damage_cool_down_timeout():
	can_take_damage = true

func _on_timer_timeout():
	queue_free()
