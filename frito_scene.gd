extends Node2D

#Animation and text control
var animation1_finished = false
var animation2_finished = false
var animation3_finished = false
var animation4_finished = false
var text1_instantiated = false

@onready var animation = $Transition
@onready var texto1 = preload("res://texto_box.tscn")
@onready var root = $"."

func _ready():
	$AnimatedSprite2D.visible = false
	$Glow.visible = false
	$Anjo.visible = false
	$Diabo.visible = false
	$Morte.visible = false
	$Morto.visible = false
	$Button.visible = false

	
func _physics_process(delta):
	if !animation1_finished:
		play_once_galinho()
		$Timer1.start()
		
func play_once_galinho():
	$AnimationPlayer.play("frito_walk")
	animation1_finished = true
	
func play_reaction():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("emotion")
	animation2_finished = true

func play_glow():
	$Glow.visible = true
	$Glow.play("glow")
	
func play_intern_fight():
	$AnimatedSprite2D.visible = false
	$Anjo.visible = true
	$Diabo.visible = true
	$Anjo.play("emoticon")
	$Diabo.play("emoticon")
	animation3_finished = true

#Timers
func _on_timer_1_timeout():
	if !animation2_finished:
			play_reaction()
			play_glow()
			$Timer2.start()

func _on_timer_2_timeout():
	if !text1_instantiated:
		var text1 = texto1.instantiate()
		root.add_child(text1)
		text1_instantiated = true
		$TimerProxAnimation.start()

func _on_timer_prox_animation_timeout():
	if !animation3_finished:
		play_intern_fight()
		$UltimoTimer.start()

func _on_ultimo_timer_timeout():
	$Anjo.visible = false
	$Diabo.visible = false
	$AnimationPlayer.stop()
	$"1".visible = false
	$"2".visible = false
	if !animation4_finished:
		$Morte.visible = true
		$Morte.play("death")
		animation4_finished = true
		$Timer3.start()

func _on_timer_3_timeout():
	if animation4_finished:
		$Morte.visible = false
		$Glow.visible = false
		$Morto.visible = true
		$Button.visible = true


#Transition
func _on_button_pressed():
	animation.play("fade_out")

func _on_button_mouse_entered():
	$Button.icon = preload("res://assets/37_button UI.png")

func _on_button_mouse_exited():
	$Button.icon = preload("res://assets/73_button UI.png")

func _on_transition_animation_finished(anim_name):
	get_tree().change_scene_to_file("res://levels/scenes/level1.tscn")
