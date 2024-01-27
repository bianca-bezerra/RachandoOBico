extends Node2D

var allowed_levelup = false
@onready var player = get_node("/root/GaloFrito")
@onready var animation = $Transition
@onready var portal_animation = $Portal
@onready var cor = $ColorRect

func _ready():
	animation.play("fade_in")
	portal_animation.visible = false
	
func _physics_process(delta):
	if global.level1_completed == true:
		portal_animation.play("portal")
		portal_animation.visible = true

func _on_area_2d_body_entered(body):
	if body.has_method("player") and global.level1_completed == true:
			allowed_levelup = true
			$WaitTime.start()
			
func _on_wait_time_timeout():
	var tween = create_tween()
	tween.tween_property(cor,"self_modulate",Color(0,0,0),1.5)
	await tween.finished
	get_tree().change_scene_to_file("res://levels/scenes/level2.tscn")
		
