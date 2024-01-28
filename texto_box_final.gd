extends CanvasLayer

@onready var textbox_container = $"TextBoxContainer"
@onready var start_symbol = $"TextBoxContainer/MarginC/HBoxContainer/Start"
@onready var end_symbol = $"TextBoxContainer/MarginC/HBoxContainer/End"
@onready var label =$"TextBoxContainer/MarginC/HBoxContainer/Text"
@onready var tween = get_tree().create_tween()
var character_read_rate = 0.03

enum State {
	READY,
	READING,
	FINISHED
}
var current_state = State.READY
var texts = []

func _ready():

	hide_textbox()
	queue_text("Senhor: Meu deus, um galinho mortinho na porta de casa! Deus pedi uma janta, não um banquete...")
	queue_text("Frito: TÔ NÃO TA MALUCO Ô SENHOR")
	queue_text("Frito: Oxe, onde foi parar o milhão que tava ali?")
	queue_text("Senhor: Milho? Hehehehehehe")
	queue_text("Senhor: Já esta anoitecendo, precisei colocar meu disfarce para descansar, ele ainda não é de ferro...")
	queue_text("Frito: Disfarce? Não passava de uma miragem???")
	queue_text("Senhor: Miragem não...é apenas um milho falso para despistar os ladrões da minha plantação")
	queue_text("Frito: Entendo...T-T")
	queue_text("Senhor: Você parece tão fraquinho, desmaiado por aqui...")
	queue_text("Senhor: Vou lhe ajudar, meu milharal fica ali no Outro Lado!")
	queue_text("Senhor: Para chegar la é só atravessar aquela rua logo ali")
	queue_text("Frito: Sério mesmo? Posso ir?")
	queue_text("Senhor: Sim sim, é a recompensa por ser um galinho honesto e não ter roubado meu milhão")
	
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
	tween = create_tween()
	tween.tween_property(label,"visible_ratio",1,len(next_text) * character_read_rate)
	tween.connect("finished",on_tween_finished)
	
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
	
