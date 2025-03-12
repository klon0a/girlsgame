extends RemoteTransform2D
class_name ScaleTargeter

var target_scale : Vector2 = Vector2.ONE
var scale_speed : Vector2 = Vector2.ZERO
@export var stiffness : float
@export_range(0.0,1.0) var enthusiasm : float
@export_range(0.0,1.0) var damping : float
@onready var target = get_node(remote_path)
func _process(delta: float) -> void:
	scale_speed = Interpolator.spring_speed_vector(
		scale_speed, 
		scale, 
		target_scale, 
		stiffness, 
		enthusiasm, 
		delta)
	scale_speed = Interpolator.good_lerp_vector(scale_speed, Vector2.ZERO, damping, delta)
	scale += scale_speed * delta
	target.scale = scale
	
