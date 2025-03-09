extends Node2D
class_name Kitty

@onready var body: Node2D = $Body
@export var garment_parent : Node2D
@export var kitty_parts : Array[KittyPart] 
@export var color_count : int = 7
var current_kitty_color = 0
var current_top : Garment 
var current_bottom : Garment 
var current_fullbody : Garment 
var current_shoe : Garment 
#var current_eyes : Node2D 

static var cursor_over_kitty = false

func _ready() -> void:
	%Cursor.position = self.position
	pass

func cycle_kitty_color():
	current_kitty_color = (current_kitty_color + 1) % color_count
	for part : KittyPart in kitty_parts:
		part.set_sprite_id(current_kitty_color)
	pass

func _on_area_2d_mouse_entered() -> void:
	cursor_over_kitty = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	cursor_over_kitty = false
	pass # Replace with function body.

func put_on(new_garment : Garment):
	#cycle_kitty_color() # placeholder!!!
	new_garment.reparent(garment_parent)
	new_garment.position = Vector2.ZERO
	new_garment.scale = Vector2.ONE
	
	match new_garment.type:
		Garment.GARMENT_TYPE.SHOE:
			if (current_shoe != null):
				current_shoe.take_off()
			current_shoe = new_garment
			
		Garment.GARMENT_TYPE.TOP:
			if (current_top != null):
				current_top.take_off()
			if (current_fullbody != null):
				current_fullbody.take_off()
			current_top = new_garment

		Garment.GARMENT_TYPE.BOTTOM:
			if (current_bottom != null):
				current_bottom.take_off()
			if (current_fullbody != null):
				current_fullbody.take_off()
			current_bottom = new_garment
			
		Garment.GARMENT_TYPE.FULL:
			if (current_fullbody != null):
				current_fullbody.take_off()
			if (current_top != null):
				current_top.take_off()
			if (current_bottom != null):
				current_bottom.take_off()
			current_fullbody = new_garment
			
		Garment.GARMENT_TYPE.ACCESSORY:
			# i think multiple accessories are swag actually
			pass
			
	pass
