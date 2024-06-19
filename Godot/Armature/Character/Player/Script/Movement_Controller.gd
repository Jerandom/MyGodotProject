extends Node

@export var player : CharacterBody3D
@export var mesh_root : Node3D
@export var rotation_speed : float = 8
@export var fall_gravity : float = 45

var direction : Vector3
var velocity : Vector3
var acceleration : float
var speed : float
var cam_rotation : float
var jump_gravity : float = fall_gravity
var is_grounded : bool = false

func _physics_process(delta):
	#movement
	velocity.x = speed * direction.normalized().x
	velocity.z = speed * direction.normalized().z
	
	#jump
	if not player.is_on_floor():
		if velocity.y >= 0:
			velocity.y -= jump_gravity * delta
		else:
			velocity.y -= fall_gravity * delta
		
	
	player.velocity = player.velocity.lerp(velocity, acceleration * delta)
	player.move_and_slide()
	
	var target_rotation = atan2(direction.x, direction.z) - player.rotation.y
	mesh_root.rotation.y = lerp_angle(mesh_root.rotation.y, target_rotation, rotation_speed * delta)
	
func _on_set_jump_state(_jump_state : JumpState):
	velocity.y = 2 * _jump_state.jump_height / _jump_state.apex_duration
	jump_gravity = velocity.y / _jump_state.apex_duration

func _on_set_movement_state(_movement_state : StateMachine):
	speed = _movement_state.movement_speed
	acceleration = _movement_state.acceleration

func _on_set_movement_direction(_movement_direction : Vector3):
	direction = _movement_direction.rotated(Vector3.UP, cam_rotation)

func _on_set_cam_rotation(_cam_rotation : float):
	cam_rotation = _cam_rotation
