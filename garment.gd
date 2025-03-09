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
		scale = _personal_coathanger.item_scale * Vector2.ONE
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
