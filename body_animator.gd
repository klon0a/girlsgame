extends Node2D
class_name BodyAnimator

@export var floor : Node2D
@export var body : Node2D
@export var arm_l : Node2D
@export var arm_r : Node2D
@export var legs : Node2D
@export var tail : Node2D
@export var eyes : Node2D

var leg_to_floor : Vector2
func _ready() -> void:
	leg_to_floor = floor.global_position - legs.global_position
	pass

var time : float = 0.0

var breathing : float = 0.0
var breathing_speed = 0.15
var body_scale_pow = 1.02

@onready var body_start_pos : Vector2 = body.global_position
func _process(delta: float) -> void:
	time += delta
	
	# breathing
	breathing = sin(time * breathing_speed * TAU)
	body.scale.y = pow(body_scale_pow, breathing)
	body.scale.x = pow(body_scale_pow, -breathing)
	
	# swaying
	body.global_position = body_start_pos + Vector2(sin(time * 0.1 * TAU), cos(time * 0.07 * TAU)) * 5.0
	
	# legs stay put
	var current_leg_to_floor = floor.global_position - legs.global_position
	legs.scale.y = current_leg_to_floor.length() / leg_to_floor.length()
	legs.scale.x = leg_to_floor.length() / current_leg_to_floor.length()
	legs.rotation = current_leg_to_floor.angle() - leg_to_floor.angle()
	
	
	# tail sways
	# tail animates with wobbler, make separate later
	pass
