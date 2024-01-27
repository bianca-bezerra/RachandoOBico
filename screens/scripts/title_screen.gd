extends Control
@onready var cor = $ColorRect

func _on_start_button_pressed():
	#var tween = create_tween()
	#tween.tween_property(cor,"visible",true,1)
	#tween.tween_property(cor,"self_modulate",Color(0,0,0),2)
	#await tween.finished
	get_tree().change_scene_to_file("res://frito_scene.tscn")


func _on_quit_button_pressed():
	get_tree().quit();
