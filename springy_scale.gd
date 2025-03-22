extends Node2D
class_name SpringyScale

var target_scale : float = 1.0
var scale_speed : float = 0.0
var scale_value : float = 0.0
@export var scale_power : float = 1.05
@export var stiffness : float
@export_range(0.0,1.0) var enthusiasm : float
@export_range(0.0,1.0) var damping : float
func _process(delta: float) -> void:
	scale_speed = Interpolator.spring_speed(
		scale_speed, 
		scale_value, 
		target_scale, 
		stiffness, 
		enthusiasm, 
		delta)
	scale_speed = Interpolator.good_lerp(scale_speed, 0.0, damping, delta)
	scale_value += scale_speed * delta 
	scale = Vector2(pow(scale_power, scale_value), pow(scale_power, -scale_value))
	
