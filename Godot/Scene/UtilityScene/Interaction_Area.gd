extends Area3D
class_name InteractionArea

@export var action_name: String = "interact"
@export var offset_x: float = 0.0
@export var offset_y: float = 0.0
@export var offset_z: float = 0.0

var interact: Callable = func():
	pass
	
func _ready():
	var current_position = get_parent().global_transform.origin
	
	# Apply offsets to current position
	var new_position = Vector3(current_position.x + offset_x, current_position.y + offset_y, current_position.z + offset_z)
	InteractionManager.setObjectLocation(new_position)

func _on_body_entered(_body):
	InteractionManager.register_area(self)
	print("Player entered the area")


func _on_body_exited(_body):
	InteractionManager.unregister_area(self)
	print("Player exit the area")
