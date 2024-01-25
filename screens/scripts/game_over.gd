extends Control



func _on_restart_btn_pressed():
	if global.level1_completed:
		get_tree().change_scene_to_file("res://levels/scenes/level2.tscn");
	elif global.level2_completed:
		get_tree().change_scene_to_file("res://levels/scenes/level3.tscn");
	else:
		get_tree().change_scene_to_file("res://screens/scenes/title_screen.tscn");


func _on_quit_btn_pressed():
	get_tree().quit();
