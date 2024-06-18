extends Node3D

signal set_cam_roation(_cam_rotation : float)

@onready var yaw_node = $Camera_Yaw
@onready var pitch_node = $Camera_Yaw/Camera_Pitch
@onready var camera_3d = $Camera_Yaw/Camera_Pitch/SpringArm3D/Camera3D

var yaw : float = 0
var pitch : float = 0

var yaw_sensitivity : float = 0.07
var pitch_sensitivity : float = 0.07

var yaw_acceleration : float = 15
var pitch_accerleration : float = 15

var pitch_max : float = 35
var pitch_min : float = -45

var tween : Tween

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)

func _input(event):
	if event is InputEventMouseMotion:
		yaw += -event.relative.x * yaw_sensitivity
		pitch += event.relative.y * pitch_sensitivity
		
func _physics_process(delta):
	pitch = clamp(pitch,pitch_min,pitch_max)
	
	yaw_node.rotation_degrees.y = lerp(yaw_node.rotation_degrees.y, yaw, yaw_acceleration * delta)
	pitch_node.rotation_degrees.x = lerp(pitch_node.rotation_degrees.x, pitch, pitch_accerleration * delta)
	
	set_cam_roation.emit(yaw_node.rotation.y)

func _on_set_movement_state(_movement_state : StateMachine):
	if tween:
		tween.kill()
	
	tween = create_tween()
	tween.tween_property(camera_3d, "fov", _movement_state.camera_fov, 0.5).set_trans(Tween.TRANS_SINE).set_ease(Tween.EASE_OUT)
