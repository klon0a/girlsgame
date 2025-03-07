extends GridContainer
class_name ClosetShelves

@export var original_shelf_item : CoatHanger 

@onready var item_parent: GridContainer = self


var shelf_items = []

func _ready() -> void:
	item_parent.remove_child(original_shelf_item);
	pass

func create_items(count : int):
	for i in range(count):
		var item_duplicate = original_shelf_item.duplicate()
		shelf_items.append(item_duplicate)
		item_parent.add_child(item_duplicate)
		pass
	pass

func populate_shelves(_clothes_to_spawn : Array[PackedScene]):
	for item : CoatHanger in shelf_items:
		item.queue_free()
	shelf_items = []
	
	create_items(_clothes_to_spawn.size())
	
	for i in range(_clothes_to_spawn.size()):
		shelf_items[i].set_garment(_clothes_to_spawn[i])
	pass
