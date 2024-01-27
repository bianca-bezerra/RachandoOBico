
extends Area2D

var speed = 10
var direction : int = 1

func _ready():
	set_as_top_level(true)
	
func _physics_process(delta):
	move_local_x(speed)
func ovo():
	pass;

func _on_area_2d_body_entered(body):
	if body.has_method("patrulha"):
		body.hurt_state();
	
func _on_area_2d_body_exited(body):
	if body.has_method("patrulha"):
		body.hurt_state();
