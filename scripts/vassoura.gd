extends Area2D

@onready var animation = $WeaponPivot/AnimatedSprite2D
@onready var ovo = preload("res://scenes/ovo.tscn")
@onready var place = $WeaponPivot/AnimatedSprite2D/ShootingPoint
var can_fire = false

func _physics_process(delta):
	var enemies_in_range = get_overlapping_bodies()
	if enemies_in_range.size() > 0:
		var target_enemy = enemies_in_range.front()
		
func shoot():
	var new_bullet = ovo.instantiate()
	var tween = create_tween()
	tween.tween_property(animation,"frame",3,1)
	#new_bullet.global_position =place.global_position
	#new_bullet.global_rotation = place.global_rotation
	place.add_child(new_bullet)
	can_fire = false

