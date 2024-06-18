extends StaticBody3D

@onready var interaction_area = $InteractionArea

func _ready():
	interaction_area.interact = Callable(self, "_interact_PC")
	
func _interact_PC():
	visible = false
	return null
