extends Control
class_name Closet

@onready var closet_scroll: ClosetScroll = $ClosetInside/ClosetScroll
@onready var closet_shelves: ClosetShelves = $ClosetInside/ClosetShelves

@export var tops_list : Array[PackedScene]
@export var bottoms_list : Array[PackedScene]
@export var fulls_list : Array[PackedScene]

@export var shoes_list : Array[PackedScene]

@export var accessories_list : Array[PackedScene]

enum CATEGORY {TOPS, BOTTOMS, SHOES, ACCESSORIES}
static var _category : CATEGORY
var current_category : CATEGORY :
	get:
		return _category
	set(value): 
		_category = value
		
		# make the right ones visible
		match _category:
			Closet.CATEGORY.TOPS or Closet.CATEGORY.BOTTOMS:
				closet_scroll.visible = true
				closet_shelves.visible = false
				pass
			
			Closet.CATEGORY.SHOES or Closet.CATEGORY.ACCESSORIES:
				#closet_scroll.visible = false
				closet_scroll.visible = true
				#closet_shelves.visible = true
				pass
		
		match _category:
			Closet.CATEGORY.TOPS:
				var combined_tops_and_fulls = tops_list.duplicate() 
				combined_tops_and_fulls.append_array(fulls_list.duplicate())
				closet_scroll.populate_coathangers(combined_tops_and_fulls)
				
			Closet.CATEGORY.BOTTOMS:
				var combined_bottoms_and_fulls = bottoms_list.duplicate() 
				combined_bottoms_and_fulls.append_array(fulls_list.duplicate())
				closet_scroll.populate_coathangers(combined_bottoms_and_fulls)
				pass
			
			Closet.CATEGORY.SHOES:
				closet_scroll.populate_coathangers(shoes_list)
				pass
			Closet.CATEGORY.ACCESSORIES:
				closet_scroll.populate_coathangers(accessories_list)
				pass


func _on_tops_category_pressed() -> void:
	pass # Replace with function body.


func _on_bottoms_category_pressed() -> void:
	pass # Replace with function body.


func _on_shoes_category_pressed() -> void:
	pass # Replace with function body.


func _on_accessories_category_pressed() -> void:
	pass # Replace with function body.
