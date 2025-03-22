extends Node2D
class_name Kitty

@onready var wear_sound: AudioStreamPlayer = $WearSound

@onready var body: Node2D = $Body
@export var garment_parent : Node2D
@export var kitty_parts : Array[KittyPart] 
@export var eyes : KittyPart
@export var blink_eyes: Sprite2D

@export var color_count : int = 7
@export var eye_count : int = 7

@export var parent_head : Node2D
@export var parent_body : Node2D
@export var parent_arm_l : Node2D
@export var parent_arm_r : Node2D
@export var parent_legs : Node2D

var current_kitty_color = 0
var current_eyeset = 0
var current_top : Garment 
var current_bottom : Garment 
var current_fullbody : Garment 
var current_shoe : Garment 
#var current_eyes : Node2D 

static var cursor_over_kitty = false
static var global_garment_scale : float
static var instance : Kitty

func _ready() -> void:
	%Cursor.position = self.position
	global_garment_scale = garment_parent.global_scale.x
	instance = self
	pass

func cycle_kitty_color():
	current_kitty_color = (current_kitty_color + 1) % color_count
	for part : KittyPart in kitty_parts:
		part.set_sprite_id(current_kitty_color)
	pass

func cycle_eyes():
	current_eyeset = (current_eyeset + 1) % eye_count
	eyes.set_sprite_id(current_eyeset)
	pass

func _on_area_2d_mouse_entered() -> void:
	cursor_over_kitty = true
	pass # Replace with function body.


func _on_area_2d_mouse_exited() -> void:
	cursor_over_kitty = false
	pass # Replace with function body.

func put_on(new_garment : Garment):
	wear_sound.play()
	#cycle_kitty_color() # placeholder!!!
	new_garment.prep_to_be_put_on()
	new_garment.reparent(garment_parent)
	new_garment.position = Vector2.ZERO
	new_garment.rotation = 0.0
	new_garment.scale = Vector2.ONE
	parent_clothes(new_garment)
	
	match new_garment.type:
		Garment.GARMENT_TYPE.SHOE:
			if (current_shoe != null):
				current_shoe.take_off()
			current_shoe = new_garment
			
		Garment.GARMENT_TYPE.TOP:
			#if (current_top != null):
				#current_top.take_off()
			#if (current_fullbody != null):
				#current_fullbody.take_off()
			#current_top = new_garment
			pass

		Garment.GARMENT_TYPE.BOTTOM:
			#if (current_bottom != null):
				#current_bottom.take_off()
			#if (current_fullbody != null):
				#current_fullbody.take_off()
			#current_bottom = new_garment
			pass
			
		Garment.GARMENT_TYPE.FULL:
			#if (current_fullbody != null):
				#current_fullbody.take_off()
			#if (current_top != null):
				#current_top.take_off()
			#if (current_bottom != null):
				#current_bottom.take_off()
			#current_fullbody = new_garment
			pass
			
		Garment.GARMENT_TYPE.ACCESSORY:
			# i think multiple accessories are swag actually
			pass
			
	pass

func remove_picked_up_garment(removed_garment : Garment):
	if current_shoe == removed_garment:
		current_shoe = null
	if current_top == removed_garment:
		current_top = null
	if current_bottom == removed_garment:
		current_bottom = null
	if current_fullbody == removed_garment:
		current_fullbody = null
	unparent_clothes(removed_garment)


func parent_clothes(garment : Garment):
	for part in garment.garment_parts:
		var part_z = part.z_index
		print(part.name + " " + str(part_z))
		match part_z:
			14, 13, 0: # accessory, head
				part.reparent(parent_head)
			12, 11: # left sleeve
				part.reparent(parent_arm_l)
			10, 8: # body
				part.reparent(parent_body)
			7, 6: # right sleeve
				part.reparent(parent_arm_r)
			9, 5, 4, 3, 2, 1: # bottoms
				part.reparent(parent_legs)
		part.position = Vector2.ZERO
		part.rotation = 0.0
	pass

func unparent_clothes(garment : Garment):
	for part in garment.garment_parts:
		part.reparent(garment)
	pass

func _on_blink_timer_timeout() -> void:
	$BlinkTimer.wait_time = randf_range(4.0, 8.0)
	blink_eyes.visible = true
	eyes.visible = false
	await get_tree().create_timer(0.12).timeout
	blink_eyes.visible = false
	eyes.visible = true
