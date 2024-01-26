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
	queue_text("Galo Frito era um querido galinho da vizinhança Penas e Penugens, zona rural do município de São Poleiro")
	queue_text("Na sua trajetória diária até o outro lado da rua, Frito se depara com o maior milho que já viu na sua vida inteira ! ! *O*")
	queue_text("No seu primeiro instito de galinho selvagem, pensa na possibilidade de tomá-lo para si IMEDIATAMENTE")
	queue_text("MÂS, sua mente se divide numa luta interna intensa entre duas (de muitas) vozes da sua cabeça")
	queue_text("A voz do anjo (que sussurrou no ouvido dele) e a voz do demônio, cada um tentando o convencer a fazer uma escolha sobre aquele milhão")
	queue_text("O anjo diz: Não seja vacilão galinho! Não pegue no milhão")
	queue_text("O demônio diz: Não seja um frango! É só pegar e sair correndo. Tá com pena?")
	queue_text("Frito não tanka a dualidade de sua mente e vai com Deus...")
	
	
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
	
