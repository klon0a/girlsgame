extends Control
class_name CoatHanger

var garment : Node2D
@export var attach_point : Node2D
@export_range(0.0, 1.0) var item_scale : float

func set_garment(new_garment : PackedScene, _material : Material):
	if garment != null:
		garment.queue_free()
	
	var instantiated_garment : Garment = new_garment.instantiate()
	add_child(instantiated_garment)
	instantiated_garment._cursor = Cursor.instance
	instantiated_garment.scale = Vector2.ONE * item_scale
	instantiated_garment.position = attach_point.global_position - instantiated_garment.hang_point.global_position
	garment = instantiated_garment
	garment.material = _material
