extends Node2D
@onready var balao = preload("res://speech_baloon.tscn")
const lines = [
	"oIIII",
	"Olaaaaa",
	"3",
	"4",
	"5"
];

func _physics_process(delta):
	if Input.is_action_just_pressed("ui_accept"):
		DialogManager.start_dialog(Vector2.ZERO,lines)
