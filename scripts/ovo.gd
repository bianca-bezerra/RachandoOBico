
extends Area2D

var speed = 10
var direction : int

func _physics_process(delta):
	move_local_x(speed)
	await get_tree().create_timer(0.3).timeout
	queue_free()
	

