extends Node3D

@onready var player = get_tree().get_first_node_in_group("Player")
@onready var label = $Sprite3D/SubViewport/Label
@onready var sub_viewport = $Sprite3D/SubViewport
@onready var sprite_3d = $Sprite3D

const base_text = "[E] to "

var active_areas = []
var can_interact = false

# set position from parent object
func setObjectLocation(position: Vector3):
	sprite_3d.position = position

# add object to an array UI
func register_area(area: InteractionArea):
	can_interact = true
	active_areas.push_back(area);
	
# remove object to an array UI
func unregister_area(area: InteractionArea):
	can_interact = false
	var index = active_areas.find(area)
	
	if(index != -1):
		active_areas.remove_at(index)

# sorting function for distance check
func _sort_by_distance_to_player(area1, area2):
	var area1_to_player = player.global_position.distance_to(area1.global_position)
	var area2_to_player = player.global_position.distance_to(area2.global_position)
	return area1_to_player < area2_to_player

func _process(_delta):
	if active_areas.size() > 0 && can_interact:
		active_areas.sort_custom(_sort_by_distance_to_player)
		
		label.text = base_text + active_areas[0].action_name
		sub_viewport.size = label.size
		sprite_3d.show()
	else:
		sprite_3d.hide()

func _input(event):
	if event.is_action_pressed("Interact") && can_interact:
		if active_areas.size() > 0:
			can_interact = false;
			sprite_3d.hide()
			
			await active_areas[0].interact.call()
			can_interact = true
