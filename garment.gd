extends Node2D
class_name Garment

enum GARMENT_TYPE {SHOE, BOTTOM, TOP, ACCESSORY, FULL}

@export var hang_point : Marker2D
@export var type : GARMENT_TYPE
var _cursor : Cursor

func _on_touch_screen_button_pressed() -> void:
	#print("garment touched! " + name)
	if Cursor.can_grab:
		Cursor.instance.held_garment = self
	pass # Replace with function body.

func take_off():
	queue_free()
	pass
