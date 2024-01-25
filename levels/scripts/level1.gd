extends Node2D

var allowed_levelup = false
@onready var player = get_node("/root/GaloFrito")

func _on_area_2d_body_entered(body):
	if body.has_method("player") and global.level1_completed == true:
			allowed_levelup = true
			$WaitTime.start()
			

func _on_wait_time_timeout():
	get_tree().change_scene_to_file("res://levels/scenes/level2.tscn")
