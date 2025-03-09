extends Sprite2D
class_name KittyPart

@export var sprites : Array[Texture2D]

func set_sprite_id(id : int):
	texture = sprites[id]
	$Shadow.texture = texture
	pass
