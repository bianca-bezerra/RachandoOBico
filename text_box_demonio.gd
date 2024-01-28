extends CanvasLayer

@onready var textbox_container = $"TextBoxContainer"
@onready var start_symbol = $"TextBoxContainer/MarginC/HBoxContainer/Start"
@onready var end_symbol = $"TextBoxContainer/MarginC/HBoxContainer/End"
@onready var label =$"TextBoxContainer/MarginC/HBoxContainer/Text"
@onready var tween = get_tree().create_tween()
var character_read_rate = 0.03
var effect_tween: Tween

enum State {
	READY,
	READING,
	FINISHED
}
var current_state = State.READY
var texts = []

func _ready():

	hide_textbox()    
	queue_text("GALINHO DEMONIO:
								Por que mirou logo na minha cabeca? De galo na minha vida ja basta voce...")
	
func _physics_process(delta):
	
	match current_state:
		State.READY:
			if !texts.is_empty():
				display_text()
		State.READING:
			if Input.is_action_just_pressed("ui_accept"):
				label.visible_ratio = 1.0
				tween.stop()
				end_symbol.text = "v"
				change_state(State.FINISHED)
		State.FINISHED:
			if Input.is_action_just_pressed("ui_accept"):
				change_state(State.READY)
				hide_textbox()
			
		
func hide_textbox():
	start_symbol.text = ""
	end_symbol.text = ""
	label.text = ""
	textbox_container.hide()
	
func queue_text(next_text):
	texts.push_back(next_text)

	
func show_textbox():
	start_symbol.text = "*"
	textbox_container.show()

func display_text():
	var next_text = texts.pop_front()
	label.text = next_text
	change_state(State.READING)
	show_textbox()
	if effect_tween:
		effect_tween.kill()
	effect_tween = create_tween()
	effect_tween.connect("finished",Callable(self,"on_tween_finished"))
	effect_tween.tween_property(label,"visible_ratio",1,len(next_text) * character_read_rate)

func on_tween_finished():
	end_symbol.text = "v"
	change_state(State.FINISHED)

func change_state(next_state):
	current_state = next_state
	
	match current_state:
		State.READY:
			pass
		State.READING:
			pass
		State.FINISHED:
			pass
	
