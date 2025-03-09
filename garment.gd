extends Node2D
class_name Garment

enum GARMENT_TYPE {SHOE, BOTTOM, TOP, ACCESSORY, FULL}

@export var hang_point : Marker2D
@export var type : GARMENT_TYPE
var _cursor : Cursor
var _personal_coathanger : CoatHanger

func _on_touch_screen_button_pressed() -> void:
	#print("garment touched! " + name)
	if Cursor.can_grab:
		Cursor.instance.held_garment = self
	pass # Replace with function body.

func take_off():
	return_to_closet()
	pass

func return_to_closet():
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
		scale = _personal_coathanger.item_scale * Vector2.ONE
		position = _personal_coathanger.attach_point.global_position - hang_point.global_position
	pass
