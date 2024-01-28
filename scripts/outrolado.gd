extends Node2D

func _ready():
	$Transition.play("fade_in")
	$AnimatedSprite2D.play("bicar")
	$Timer.start()
	$ColorRect.visible = false
	$ColorRect/Label.visible = false
	
func _on_timer_timeout():
	$TextBox.visible = false
	$ColorRect.visible = true
	$ColorRect/Label.visible = true
	
