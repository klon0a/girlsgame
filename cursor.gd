extends Node2D
class_name Cursor


static var instance : Cursor
static var can_grab : bool :
	get:
		return not is_instance_valid(instance.held_garment)
var _held_garment : Garment
var held_garment : Garment :
	get: 
		return _held_garment
	set(value):
		if _held_garment == null:
			_held_garment = value
			_held_garment.reparent(%Cursor)
			print("taking garment! " + _held_garment.name)
		elif value == null:
			print("dropping garment! " + _held_garment.name)
			_held_garment = null;

var held_offset : Vector2 = Vector2.ZERO

func _ready() -> void:
	instance = self

#@export var garment_lerp = 5.0
var held_garment_speed : Vector2 = Vector2.ZERO
const carry_stiffness = 40.0 # lower = slower
const carry_enthusiasm = 0.02 # lower = faster motion
const carry_damping = 0.005 # lower = more damping
func _process(delta: float) -> void:
	if not is_instance_valid(held_garment): return
	held_garment.base_scale = Interpolator.good_lerp(
				held_garment.base_scale, Kitty.global_garment_scale, 0.05, delta)
	held_garment_speed = Interpolator.spring_speed_vector(
			held_garment_speed, 
			held_garment.global_position, 
			get_global_mouse_position(), 
			carry_stiffness, 
			carry_enthusiasm, 
			delta)
	held_garment_speed = Interpolator.good_lerp_vector(held_garment_speed, Vector2.ZERO, carry_damping, delta)
	held_garment.global_position += held_garment_speed * delta
	#held_garment.global_position = lerp(held_garment.global_position, get_global_mouse_position(), delta * garment_lerp)
	if (held_garment != null) and Input.is_action_just_released("click"):
		if %Kitty.cursor_over_kitty:
			%Kitty.put_on(held_garment)
		else:
			held_garment.drop()
		
		held_garment = null
	pass
