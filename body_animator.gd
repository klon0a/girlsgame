extends Node2D
class_name BodyAnimator

@export var floor : Node2D
@export var body : SpringyScale
@export var arm_l : SpringyRotate
@export var arm_r : SpringyRotate
@export var legs : Node2D
@export var tail : SpringyRotate
@export var eyes : SpringyScale
@export var eyes_rotation : Node2D
@export var head : SpringyScale

static var instance : BodyAnimator 

var leg_to_floor : Vector2
func _ready() -> void:
	instance = self
	leg_to_floor = floor.global_position - legs.global_position
	pass

var time : float = 0.0

var breathing : float = 0.0
var breathing_speed = 0.2

var leg_bop : float = 0.0
var leg_spd : float = 0.0



@onready var body_start_pos : Vector2 = body.global_position
func _process(delta: float) -> void:
	time += delta
	
	# breathing
	breathing = sin(time * breathing_speed * TAU)
	body.target_scale = breathing
	#var breathing_scale : Vector2 = Vector2(pow(body_scale_pow, -breathing), pow(body_scale_pow, breathing))
	#body.scale = breathing_scale
	
	# swaying
	var body_sway_position = body_start_pos + Vector2(sin(time * 0.1 * TAU), cos(time * 0.07 * TAU) * 0.7) * 7.0
	
	# body squats when legs react
	leg_spd = Interpolator.spring_speed(
		leg_spd, 
		leg_bop, 
		0.0, 
		10.0, 
		0.02, 
		delta)
	leg_spd = Interpolator.good_lerp(leg_spd, 0.0, 0.2, delta)
	leg_bop += leg_spd * delta
	
	# apply to body
	body.global_position = body_sway_position + Vector2.DOWN * leg_bop
	
	# legs stay put after body moves
	var current_leg_to_floor = floor.global_position - legs.global_position
	legs.scale.y = current_leg_to_floor.length() / leg_to_floor.length()
	legs.scale.x = leg_to_floor.length() / current_leg_to_floor.length()
	legs.rotation = current_leg_to_floor.angle() - leg_to_floor.angle()
	
	eyes_rotation.rotation = Interpolator.good_lerp(eyes_rotation.rotation, 0.0, 0.5, delta)
	pass

func bop_head():
	head.scale_speed += 10.0
	pass

func bop_eyes():
	eyes.scale_speed -= 10.0
	eyes_rotation.rotate(randf_range(-1,1) * 0.1)
	pass

func bop_body():
	body.scale_speed += 15.0
	pass

func bop_l():
	arm_l.rotation_speed += 2.0
	pass

func bop_r():
	arm_r.rotation_speed += 2.0
	pass

func bop_legs():
	leg_spd += 50.0
	bop_tail()
	pass

func bop_tail():
	tail.rotation_speed += 2.0
	pass
