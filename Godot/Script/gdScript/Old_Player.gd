extends CharacterBody3D

@onready var camera_mount = $Camera_Mount
@onready var armature = $Armature
@onready var animation_tree = $AnimationTree

const JUMP_VELOCITY = 4.5

var SPEED = 3.0
var walk_Speed = 3
var run_Speed = 8
var MovementBlend_Position = -1.0

@export var x_speed = 0.5
@export var y_speed = 0.5

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# set the mouse mode
func _ready():
	Input.mouse_mode = Input.MOUSE_MODE_CAPTURED 

# set the mouse movement to rotate along with the character
func _input(event):
	if event is InputEventMouseMotion:
		rotate_y(deg_to_rad(-event.relative.x * y_speed))
		
		armature.rotate_y(deg_to_rad(event.relative.x * y_speed))
		camera_mount.rotate_x(deg_to_rad(-event.relative.y * x_speed))
		
func _process(delta):
	update_animation_parameters(delta)

func _physics_process(delta):
	# set walk run speed
	if Input.is_action_pressed("L_Shift"):
		SPEED = run_Speed
	else:
		SPEED = walk_Speed
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("A", "D", "W", "S")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
		velocity.z = direction.z * SPEED
		
		armature.look_at(position - direction)
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)
		velocity.z = move_toward(velocity.z, 0, SPEED)
		
	move_and_slide()

func update_animation_parameters(delta):
	var target_blend_position = MovementBlend_Position
	
	# running
	if (velocity.x != 0 or velocity.z != 0) and Input.is_action_pressed("L_Shift"):
		target_blend_position = 1.0
	# walking
	elif velocity.x != 0 or velocity.z != 0:
		target_blend_position = 0.0
	# idle
	else:
		target_blend_position = -1.0
		
	# Interpolate towards the target blend position
	MovementBlend_Position = lerp(MovementBlend_Position, target_blend_position, 10 * delta)
	
	# Update the animation tree
	animation_tree["parameters/MovementBlend/blend_position"] = MovementBlend_Position
