extends Label

var velocidade = 0.02

func _physics_process(delta):
	display_text()

func display_text():
	self.text = "Frito agora está no seu subconsciente para lutar pela sua sanidadee"
	var tween = create_tween()
	tween.tween_property(self,"visible_ratio",1,velocidade * len(self.text))
