extends Node2D
var animation1_finished = false
var animation2_finished = false

func _physics_process(delta):
	if !animation1_finished:
		play_once_galinho()
		$Timer.start()
		
		
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
	
func _on_timer_timeout():
	if !animation2_finished:
			play_reaction()
			play_glow()
