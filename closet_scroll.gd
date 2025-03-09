extends ScrollContainer
class_name ClosetScroll

@export var original_coathanger : CoatHanger 

@onready var coathanger_parent: HBoxContainer = $HBoxContainer

var coathangers = []

func _ready() -> void:
	coathanger_parent.remove_child(original_coathanger);
	pass

func create_coat_hangers(count : int):
	for i in range(count):
		var coat_hanger_duplicate = original_coathanger.duplicate()
		coathangers.append(coat_hanger_duplicate)
		coathanger_parent.add_child(coat_hanger_duplicate)
		pass
	pass

func populate_coathangers(_clothes_to_spawn : Array[PackedScene], _material : Material):
	for coathanger : CoatHanger in coathangers:
		coathanger.queue_free()
	coathangers = []
	
	create_coat_hangers(_clothes_to_spawn.size())
	
	for i in range(_clothes_to_spawn.size()):
		coathangers[i].set_garment(_clothes_to_spawn[i], _material)
	pass
