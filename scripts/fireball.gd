extends CharacterBody2D

var move_speed := 200;
var direction := 1; 
const FIREBALL : = 1;
const SPIKES := 2;
const BULLET := 3;
const BOMB := 4;

func fireball():
	pass

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	position.x += move_speed * direction * delta;
	#if is_on_wall():
		#$queue_free();

func set_direction(dir : int, gun = FIREBALL):
	
	direction = dir;
	if(direction == 1):
		$anim.flip_h = false;
	else:
		$anim.flip_h = true;
	if gun == FIREBALL:
		$anim.play("default");
	elif gun == SPIKES:
		$anim.play("ice");
	elif gun == BULLET:
		$anim.play("bullet");
	else:
		$anim.play("bomb");
		


#func _on_area_2d_body_entered(body):
	#if body.has_method("player"):
		#body.queue_free()  # Adicione esta linha
#
#
#func _on_area_2d_body_exited(body):
	#if body.has_method("player"):
		#body.queue_free()  # Adicione esta linha
		#
