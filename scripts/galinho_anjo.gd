extends CharacterBody2D

#Detection
var attack_mode = false

#Motion
var speed = 75
var gravity = 20
var current_direction
var jump_force = 50

#Player
@onready var player = get_node("/root/Level1/GaloFrito")

#Combat System
var health = 0
var player_inattack_range = false
var damage_rate = 30
var can_take_damage = true


func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
			
	if attack_mode:
		var target_position_x = player.position.x - position.x
		var target_position_y = player.position.y - position.y
		var direction = Vector2(target_position_x, target_position_y).normalized()

		velocity = direction * speed 
		velocity.y = direction.y * (-jump_force)
		
	if velocity.length() > 0.0:
		if velocity.x > 0.0:
			current_direction = "right"
			$AnimatedSprite2D.flip_h = true  # Flip should be false for moving right
			$AnimatedSprite2D.play("walk")
			
		else:
			current_direction = "left"
			$AnimatedSprite2D.flip_h = false  # Flip should be true for moving left
			$AnimatedSprite2D.play("walk")
	else:
		velocity = Vector2.ZERO

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
			$TakeDamageCoolDown.start()
			can_take_damage = false
			if health <= 0:
				self.queue_free()
				$AnimatedSprite2D.play("death")
				global.level1_completed = true
	print("ANJO HEALTH", health)

func _on_take_damage_cool_down_timeout():
	can_take_damage = true
