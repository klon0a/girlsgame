extends Control
class_name Closet

@onready var closet_scroll: ClosetScroll = $ClosetInside/ClosetScroll
@onready var closet_shelves: ClosetShelves = $ClosetInside/ClosetShelves
@onready var color_buttons: ColorSelector = $ColorButtons

var tops_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA
var bottoms_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA
var shoes_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA
var accessories_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA

@export var top_material : Material
@export var bottom_material : Material
@export var accessory_material : Material
@export var shoe_material : Material

@export var tops_list : Array[PackedScene]
@export var bottoms_list : Array[PackedScene]
@export var fulls_list : Array[PackedScene]

@export var shoes_list : Array[PackedScene]

@export var accessories_list : Array[PackedScene]

static var inside_rect : Rect2

enum CATEGORY {TOPS, BOTTOMS, SHOES, ACCESSORIES}
var _category : CATEGORY
var current_category : CATEGORY :
	get:
		return _category
	set(value): 
		_category = value
		$ClosetTitle/Accessories.visible = false
		$ClosetTitle/Bottoms.visible = false
		$ClosetTitle/Tops.visible = false
		# make the right ones visible
		match _category:
			Closet.CATEGORY.TOPS, Closet.CATEGORY.BOTTOMS:
				closet_scroll.visible = true
				closet_shelves.visible = false
				pass
			
			Closet.CATEGORY.SHOES, Closet.CATEGORY.ACCESSORIES:
				closet_scroll.visible = false
				closet_shelves.visible = true
				pass
		
		match _category:
			Closet.CATEGORY.TOPS:
				var combined_tops_and_fulls = tops_list.duplicate() 
				combined_tops_and_fulls.append_array(fulls_list.duplicate())
				closet_scroll.populate_coathangers(combined_tops_and_fulls, top_material)
				
				$ClosetTitle/Tops.visible = true
				
			Closet.CATEGORY.BOTTOMS:
				var combined_bottoms_and_fulls = bottoms_list.duplicate() 
				combined_bottoms_and_fulls.append_array(fulls_list.duplicate())
				closet_scroll.populate_coathangers(combined_bottoms_and_fulls, bottom_material)
				
				$ClosetTitle/Bottoms.visible = true
			
			Closet.CATEGORY.SHOES:
				closet_shelves.populate_shelves(shoes_list, shoe_material)
				
			Closet.CATEGORY.ACCESSORIES:
				closet_shelves.populate_shelves(accessories_list, accessory_material)
				$ClosetTitle/Accessories.visible = true


func _ready() -> void:
	inside_rect = $ClosetInside.get_global_rect()
	_on_tops_category_pressed()

@onready var drummy: AudioStreamPlayer = $"UI Sounds/Drummy"
func play_drummy():
	drummy.pitch_scale = randf_range(0.85, 1.15)
	drummy.play()

func _on_tops_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.TOPS
	color_buttons.chosen_option = tops_color
	pass # Replace with function body.


func _on_bottoms_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.BOTTOMS
	color_buttons.chosen_option = bottoms_color
	pass # Replace with function body.


func _on_shoes_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.SHOES
	color_buttons.chosen_option = shoes_color
	pass # Replace with function body.


func _on_accessories_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.ACCESSORIES
	color_buttons.chosen_option = accessories_color
	pass # Replace with function body.


func _on_color_buttons_new_color_chosen() -> void:
	var new_color = color_buttons.chosen_option
	match _category:
		Closet.CATEGORY.TOPS:
			tops_color = new_color
			top_material.set_shader_parameter("to", color_buttons.chosen_color)
			top_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
		
		Closet.CATEGORY.BOTTOMS:
			bottoms_color = new_color
			bottom_material.set_shader_parameter("to", color_buttons.chosen_color)
			bottom_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
		
		Closet.CATEGORY.SHOES:
			shoes_color = new_color
			shoe_material.set_shader_parameter("to", color_buttons.chosen_color)
			shoe_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
		
		Closet.CATEGORY.ACCESSORIES:
			accessories_color = new_color
			accessory_material.set_shader_parameter("to", color_buttons.chosen_color)
			accessory_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
	pass # Replace with function body.

@onready var rising: AudioStreamPlayer = $"UI Sounds/Rising"
func _on_cycle_coat_pressed() -> void:
	rising.play()
	%Kitty.cycle_kitty_color()
	pass # Replace with function body.


func _on_cycle_eyes_pressed() -> void:
	rising.play()
	%Kitty.cycle_eyes()
	pass # Replace with function body.


func _on_cycle_eye_color_pressed() -> void:
	pass # Replace with function body.


func _on_toggle_music_pressed() -> void:
	pass # Replace with function body.
