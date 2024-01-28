extends Node2D

func _ready():
	$Transition.play("fade_in")
	$AnimatedSprite2D.play("bicar")
	$Timer.start()
	$ColorRect.visible = false
	$ColorRect/Label.visible = false
	$Aplausos.play()
	
func _on_timer_timeout():
	$Aplausos.stop()
	$TextBox.visible = false
	$ColorRect.visible = true
	$ColorRect/Label.visible = true
	
