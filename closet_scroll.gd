extends ScrollContainer
class_name ClosetScroll

@export var original_coathanger : CoatHanger 
@export var clothes_list : Array[PackedScene]

@onready var coathanger_parent: HBoxContainer = $HBoxContainer

var coathangers = []

func _ready() -> void:
	coathanger_parent.remove_child(original_coathanger);
	
	create_coat_hangers(clothes_list.size())
	for i in range(clothes_list.size()):
		coathangers[i].set_garment(clothes_list[i])
	pass

func create_coat_hangers(count : int):
	for i in range(count):
		var coat_hanger_duplicate = original_coathanger.duplicate()
		coathangers.append(coat_hanger_duplicate)
		coathanger_parent.add_child(coat_hanger_duplicate)
		pass
	pass
