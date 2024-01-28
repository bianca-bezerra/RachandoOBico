extends Node2D

const speed = 100

func _process(delta):
	position += transform.x * speed * delta

func _on_timer_timeout():
		queue_free()

func _on_area_2d_body_entered(body):
	if body.has_method("player"):
		body.take_damage()

