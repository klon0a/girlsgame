extends Control
class_name ClosetShelves

@export var original_shelf_item : CoatHanger 

@export var shelf_positions : Array[Control]

var shelf_items = []

func _ready() -> void:
	remove_child(original_shelf_item);
	pass

func create_items(count : int):
	for i in range(count):
		var item_duplicate = original_shelf_item.duplicate()
		shelf_positions[shelf_items.size()].add_child(item_duplicate)
		shelf_items.append(item_duplicate)
		item_duplicate.position = Vector2.ZERO
		pass
	pass

func populate_shelves(_clothes_to_spawn : Array[PackedScene], _material : Material):
	for item : CoatHanger in shelf_items:
		item.queue_free()
	shelf_items = []
	
	create_items(_clothes_to_spawn.size())
	
	for i in range(_clothes_to_spawn.size()):
		shelf_items[i].set_garment(_clothes_to_spawn[i], _material)
	pass
