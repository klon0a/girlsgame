extends Control
class_name CoatHanger

var garment : Node2D


func set_garment(new_garment : PackedScene):
	if garment != null:
		garment.queue_free()
	var instantiated_garment : Garment = new_garment.instantiate()
	add_child(instantiated_garment)
	instantiated_garment.scale = Vector2.ONE * 0.25
	instantiated_garment.position = global_position - instantiated_garment.hang_point.global_position
	garment = instantiated_garment
