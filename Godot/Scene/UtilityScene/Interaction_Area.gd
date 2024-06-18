extends Area3D
class_name InteractionArea

@export var action_name: String = "interact"

var interact: Callable = func():
	pass

func _on_body_entered(_body):
	InteractionManager.register_area(self)
	print("Player entered the area")


func _on_body_exited(_body):
	InteractionManager.unregister_area(self)
	print("Player exit the area")
