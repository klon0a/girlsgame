extends Node2D
class_name Garment

enum GARMENT_TYPE {SHOE, BOTTOM, TOP, ACCESSORY, FULL}

@onready var grab_sound: AudioStreamPlayer = $GrabSound

@export var hang_point : Marker2D
@onready var hang_position : Vector2 = hang_point.position
@export var type : GARMENT_TYPE
var _cursor : Cursor
var _personal_coathanger : CoatHanger

var on_kitty : bool = false


var move_reaction : Vector2 = Vector2.ZERO
var move_reaction_speed : Vector2 = Vector2.ZERO

var last_frame_pos : Vector2

var base_scale : float = 1.0

var dangle_stiffness = 50.0
var dangle_enthusiasm = 0.1
var dangle_mult = 0.005
var angle_mult = 0.2
var scale_power = 1.03
var move_damping = 0.05
func _ready() -> void:
	dangle_stiffness 	*= randf_range(0.85, 1.15)
	dangle_enthusiasm	*= randf_range(0.85, 1.15)
	dangle_mult 		*= randf_range(0.85, 1.15)
	angle_mult			*= randf_range(0.85, 1.15)
	move_damping		*= randf_range(0.85, 1.15)
	

func _process(delta: float) -> void:
	move_reaction += (global_position - last_frame_pos) * dangle_mult
	move_reaction_speed += (global_position - last_frame_pos) * dangle_mult * 20.0
	last_frame_pos = global_position
	if !on_kitty:
		move_reaction_speed = Interpolator.spring_speed_vector(
				move_reaction_speed, 
				move_reaction, 
				Vector2.ZERO, 
				dangle_stiffness, 
				dangle_enthusiasm, 
				delta)
		move_reaction_speed = Interpolator.good_lerp_vector(move_reaction_speed, Vector2.ZERO, move_damping, delta)
		move_reaction += move_reaction_speed * delta
		
		rotation = move_reaction.x * angle_mult
		scale.y = pow(scale_power, -move_reaction.y) * base_scale
		scale.x = pow(scale_power, move_reaction.y) * base_scale
		# move fx
		pass
	
	pass

func reset_move_reaction():
	move_reaction = Vector2.ZERO
	move_reaction_speed = Vector2.ZERO

func _on_touch_screen_button_pressed() -> void:
	var click_inside_closet = Closet.inside_rect.has_point(get_global_mouse_position())
	#print("garment touched! " + name)
	if (click_inside_closet or on_kitty) and Cursor.can_grab:
		on_kitty = false
		Cursor.instance.held_garment = self
		grab_sound.pitch_scale = randf_range(0.85, 1.15)
		grab_sound.play()
	pass # Replace with function body.

func take_off():
	return_to_closet()
	pass

func return_to_closet():
	on_kitty = false
	if is_instance_valid(_personal_coathanger):
		place_on_hanger()
	else:
		queue_free()
	pass

func drop():
	return_to_closet()
	pass

func place_on_hanger():
	if (is_instance_valid(_personal_coathanger)):
		reparent(_personal_coathanger)
		position = Vector2.ZERO
		base_scale = _personal_coathanger.item_scale
		for child in get_children():
			if not child is Node2D: continue
			child.position = -hang_position
		#position = _personal_coathanger.attach_point.global_position - hang_point.global_position
	pass

func prep_to_be_put_on():
	on_kitty = true
	for child in get_children():
		if not child is Node2D: continue
		child.position = Vector2.ZERO
	pass
