extends Label
#@onready var galinho = $"../GaloFrito"

func _physics_process(delta):
	self.text = str("HP: ") + str(get_parent().get_parent().health)
