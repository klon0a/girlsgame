extends Node2D
class_name Garment

enum GARMENT_TYPE {SHOE, BOTTOM, TOP, ACCESSORY, FULL}

@onready var grab_sound: AudioStreamPlayer = $GrabSound

@export var hang_point : Marker2D
@onready var hang_position : Vector2 = hang_point.position * 0.609
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

var garment_parts : Array[Sprite2D]
func _ready() -> void:
	dangle_stiffness 	*= randf_range(0.85, 1.15)
	dangle_enthusiasm	*= randf_range(0.85, 1.15)
	dangle_mult 		*= randf_range(0.85, 1.15)
	angle_mult			*= randf_range(0.85, 1.15)
	move_damping		*= randf_range(0.85, 1.15)
	
	for child in get_children():
		if child is Sprite2D:
			if child.visible:
				garment_parts.append(child)
	

func _process(delta: float) -> void:
	if !reset_move_next_frame:
		move_reaction += (global_position - last_frame_pos) * dangle_mult
		move_reaction_speed += (global_position - last_frame_pos) * dangle_mult * 20.0
	last_frame_pos = global_position
	if reset_move_next_frame:
		reset_move_next_frame = false
		#reset_move_reaction()
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

var reset_move_next_frame = false
func reset_move_reaction_next_frame():
	reset_move_next_frame = true

func reset_move_reaction():
	move_reaction = Vector2.ZERO
	move_reaction_speed = Vector2.ZERO

func pick_up():
	if (get_parent() == _personal_coathanger):
		material = material.duplicate()
	z_index = 15
	on_kitty = false
	Cursor.instance.held_garment = self
	grab_sound.pitch_scale = randf_range(0.85, 1.15)
	grab_sound.play()
	global_position -= move_children_to(-hang_position)
	pass

func _on_touch_screen_button_pressed() -> void:
	var click_inside_closet = Closet.inside_rect.has_point(get_global_mouse_position())
	#print("garment touched! " + name)
	if (click_inside_closet or on_kitty) and Cursor.can_grab:
		if on_kitty:
			Kitty.instance.remove_picked_up_garment(self)
		pick_up()
	pass # Replace with function body.

func take_off():
	_return_to_closet()
	pass

func _return_to_closet():
	on_kitty = false
	if is_instance_valid(_personal_coathanger):
		place_on_hanger()
	else:
		queue_free()
	pass

func drop():
	_return_to_closet()
	pass

func place_on_hanger():
	z_index = 0
	if (is_instance_valid(_personal_coathanger)):
		material = _personal_coathanger.saved_material
		reparent(_personal_coathanger)
		position = _personal_coathanger.attach_point.position
		base_scale = _personal_coathanger.item_scale
		move_children_to(-hang_position)
		#position = _personal_coathanger.attach_point.global_position - hang_point.global_position
	pass

func prep_to_be_put_on():
	z_index = 0
	on_kitty = true
	move_children_to(Vector2.ZERO)
	pass

func move_children_to(_position : Vector2) -> Vector2:
	var prev_child_gp = get_child(0).global_position
	for child in get_children():
			if not child is Node2D: continue
			child.position = _position
	return get_child(0).global_position - prev_child_gp
