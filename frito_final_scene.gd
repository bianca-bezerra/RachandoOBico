extends Node2D

@onready var man_animation = $Old_man
var played = false
@onready var corn = $corn
@onready var galinho = $Galinho
@onready var botao = $Button
@onready var texto = preload("res://texto_box_final.tscn")
@onready var root = $"."
@onready var morto = $Morto
@onready var transition = $Transition
@onready var cor = $ColorRect
@onready var balao_duvida = $BalaoDuvida
@onready var balao_fala = $BalaoFala
@onready var balao_fofo = $BalaoCute
func _ready():
	$Musica.play()
	transition.play("fade_in")
	corn.visible = false
	balao_duvida.visible = false
	balao_fala.visible = false
	balao_fofo.visible = false
	$Button.visible = false
	$Label.visible = false
	if !played:
		play_man()
		play_dialog1()
		
func play_dialog1():
	var texto_instace1 = texto.instantiate()
	root.add_child(texto_instace1)
	
func play_man():
	var tween = create_tween()
	tween.parallel().tween_property(man_animation,"position",$Morto.position - Vector2(-30,0),2)
	tween.parallel().tween_property(man_animation,"frame",3,2)
	tween.tween_property(man_animation,"animation","idle",2)
	$Timer.start()
	played = true
	
func _on_timer_timeout():
	play_reaction1()
	
func play_reaction1():
	morto.visible = false
	var tween = create_tween()
	tween.tween_property(galinho,"animation","rise",2)
	tween.parallel().tween_property(galinho,"frame",7,1.5)
	tween.parallel().tween_property(galinho,"position",$Morto.position,2)
	$Timer2.start()
	
func _on_timer_2_timeout():
	play_man2()
	
func play_man2():
	var tween = create_tween()
	tween.tween_property(galinho,"animation","idle",2)
	tween.tween_property(galinho,"frame",4,7)
	tween.tween_property(man_animation,"animation","idle",2)
	tween.tween_property(man_animation,"frame",4,7)
	balao_duvida.visible = true
	balao_duvida.play("duvida")
	$Timer3.start()
	
func play_fade_out():
	var tween = create_tween()
	tween.tween_property(cor,"self_modulate",Color(0,0,0),2)
	tween.connect("finished",finish)

func _on_timer_3_timeout():
	balao_duvida.visible = false
	balao_fala.visible = true
	balao_fala.play("fala")
	$Button.visible = true
	$Label.visible = true

func _on_button_pressed():
	$Button.visible = false
	$Label.visible = false
	balao_duvida.visible = false
	balao_fala.visible = false
	play_fade_out()

func finish():
	get_tree().change_scene_to_file("res://scenes/outrolado.tscn")
	
func _on_button_mouse_entered():
	$Button.icon = preload("res://assets/73_button UI.png")

func _on_button_mouse_exited():
	$Button.icon = preload("res://assets/37_button UI.png")
