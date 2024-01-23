extends CharacterBody2D

var speed = 15
var gravity = 20
@onready var player = get_node("/root/Level1/GaloFrito")

func _ready():
	$AnimatedSprite2D.play("idle")

func _physics_process(delta):
	if !is_on_floor():
		velocity.y += gravity
		if velocity.y > 1000:
			velocity.y = 1000
	
	if attack_mode:
		var target_position = (player.position.x - position.x)
		velocity.x = target_position * speed
	move_and_slide()

var attack_mode = false

func _on_detection_area_body_entered(body):
	if body.has_method("player"):
		attack_mode = true
	
func _on_detection_area_body_exited(body):
	if body.has_method("player"):
		attack_mode = false

func enemy():
	pass
