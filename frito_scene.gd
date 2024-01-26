extends Node2D
var animation1_finished = false
var animation2_finished = false

@onready var texto1 = preload("res://texto_box.tscn")
@onready var root = $"."
 	
func _physics_process(delta):
	if !animation1_finished:
		play_once_galinho()
		$Timer1.start()
		
func play_once_galinho():
	$AnimationPlayer.play("frito_walk")
	$AnimatedSprite2D.visible = false
	$Glow.visible = false
	animation1_finished = true
	
func play_reaction():
	$AnimatedSprite2D.visible = true
	$AnimatedSprite2D.play("emotion")
	animation2_finished = true

func play_glow():
	$Glow.visible = true
	$Glow.play("glow")

func play_2_reaction():
	if animation2_finished:
		pass
func _on_timer_1_timeout():
	if !animation2_finished:
			play_reaction()
			play_glow()
			$Timer2.start()

var text1_instantiated = false

func _on_timer_2_timeout():
	if !text1_instantiated:
		var text1 = texto1.instantiate()
		root.add_child(text1)
		text1_instantiated = true
		
