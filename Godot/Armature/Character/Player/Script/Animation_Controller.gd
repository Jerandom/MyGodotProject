extends Node

@export var animation_tree : AnimationTree
@export var player : CharacterBody3D

var tween : Tween

func _on_set_jump_state(_jump_state : JumpState):
	animation_tree["parameters/Ground_Jump/request"] = AnimationNodeOneShot.ONE_SHOT_REQUEST_FIRE

func _on_set_movement_state(_movement_state : StateMachine):
	if tween:
		tween.kill()

	tween = create_tween()
	tween.tween_property(animation_tree, "parameters/Movement_Blend/blend_position", _movement_state.id, 0.25)
	tween.parallel().tween_property(animation_tree, "parameters/Movement_Anim_Speed/scale", _movement_state.animation_speed, 0.7)
