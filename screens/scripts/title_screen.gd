extends Control
@onready var cor = $ColorRect
@onready var botao = $Botao
func _ready():
	$Musica.play()

func _on_start_button_pressed():
	botao.play()
	$Timer.start()
	#var tween = create_tween()
	#tween.tween_property(cor,"visible",true,1)
	#tween.tween_property(cor,"self_modulate",Color(0,0,0),2)
	#await tween.finished
func _on_quit_button_pressed():
	get_tree().quit();

func _on_timer_timeout():
	get_tree().change_scene_to_file("res://frito_scene.tscn")
