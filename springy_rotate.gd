extends Node2D
class_name SpringyRotate

var target_rotation : float = 0.0
var rotation_speed : float = 0.0
var rotation_value : float = 0.0
@export var rotation_multiplier = 1.0
@export var stiffness : float = 20.0
@export_range(0.0,1.0) var enthusiasm : float = 0.01
@export_range(0.0,1.0) var damping : float = 0.2
func _process(delta: float) -> void:
	rotation_speed = Interpolator.spring_speed(
		rotation_speed, 
		rotation_value, 
		target_rotation, 
		stiffness, 
		enthusiasm, 
		delta)
	rotation_speed = Interpolator.good_lerp(rotation_speed, 0.0, damping, delta)
	rotation_value += rotation_speed * delta 
	rotation = rotation_multiplier * rotation_value
	
