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


func _on_tops_category_pressed() -> void:
	current_category = CATEGORY.TOPS
	color_buttons.chosen_option = tops_color
	pass # Replace with function body.


func _on_bottoms_category_pressed() -> void:
	current_category = CATEGORY.BOTTOMS
	color_buttons.chosen_option = bottoms_color
	pass # Replace with function body.


func _on_shoes_category_pressed() -> void:
	current_category = CATEGORY.SHOES
	color_buttons.chosen_option = shoes_color
	pass # Replace with function body.


func _on_accessories_category_pressed() -> void:
	current_category = CATEGORY.ACCESSORIES
	color_buttons.chosen_option = accessories_color
	pass # Replace with function body.


func _on_color_buttons_new_color_chosen() -> void:
	var new_color = color_buttons.chosen_option
	match _category:
		Closet.CATEGORY.TOPS:
			tops_color = new_color
			top_material.set_shader_parameter("to", tops_color)
		
		Closet.CATEGORY.BOTTOMS:
			bottoms_color = new_color
			bottom_material.set_shader_parameter("to", bottoms_color)
		
		Closet.CATEGORY.SHOES:
			shoes_color = new_color
			shoe_material.set_shader_parameter("to", shoes_color)
		
		Closet.CATEGORY.ACCESSORIES:
			accessories_color = new_color
			accessory_material.set_shader_parameter("to", accessories_color)
	pass # Replace with function body.
