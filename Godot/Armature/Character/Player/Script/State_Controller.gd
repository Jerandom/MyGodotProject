extends CharacterBody3D

signal set_movement_state(_movement_state : StateMachine)
signal set_movement_direction(_movement_direction : Vector3)
signal set_jump_state(_jump_state : JumpState)

@export var movement_states : Dictionary
@export var jump_states : Dictionary

var movement_direction : Vector3

func _ready():
	set_movement_state.emit(movement_states["Idle"])
	
func _physics_process(_delta):
	if is_movement_ongoing():
		set_movement_direction.emit(movement_direction)
	
func _input(event):
	# handle movements
	if event.is_action("Movement"):
		movement_direction.x = Input.get_action_strength("Left") - Input.get_action_strength("Right")
		movement_direction.z = Input.get_action_strength("Forward") - Input.get_action_strength("Backward")
		
		if is_movement_ongoing():
			if Input.is_action_pressed("Run"):
				set_movement_state.emit(movement_states["Run"])
			else:
				set_movement_state.emit(movement_states["Walk"])
		else:
			set_movement_state.emit(movement_states["Idle"])
			
	# handle jump
	if is_on_floor():
		if Input.is_action_just_pressed("Jump"):
			movement_direction.y = Input.get_action_strength("Jump")
			set_jump_state.emit(jump_states["Jump"])

func is_movement_ongoing() -> bool:
	return abs(movement_direction.x) > 0 or abs(movement_direction.z) > 0

