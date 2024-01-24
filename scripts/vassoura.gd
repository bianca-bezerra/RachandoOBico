extends Area2D


func _physics_process(delta):
	
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		look_at(target_enemy.global_position)
	
func shoot():
	const EXPLOSAO = preload("res://scenes/projetil.tscn")
	var new_bullet = EXPLOSAO.instantiate()
	%Batida.play("hit")
	new_bullet.global_position = %ShootingPoint.global_position
	new_bullet.global_rotation = %ShootingPoint.global_rotatio
	%ShootingPoint.add_child(new_bullet)
	
func _on_timer_timeout():
	shoot()
