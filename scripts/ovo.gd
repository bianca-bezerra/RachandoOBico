extends Area2D

var speed = 10
var direction : int = 1


func _physics_process(delta):
	move_local_x(speed * direction)
	await get_tree().create_timer(0.3).timeout
	queue_free()

func ovo():
	pass;

func _on_area_2d_body_entered(body):
	if body.has_method("patrulha"):
		body.hurt_state();

func _on_area_2d_body_exited(body):
	if body.has_method("patrulha"):
		body.hurt_state();
