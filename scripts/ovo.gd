
extends Area2D

var speed = 30
var direction : int

func _physics_process(delta):
	move_local_x(speed)
	
func _on_timer_timeout():
	queue_free()
