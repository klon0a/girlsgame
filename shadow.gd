extends Sprite2D


@onready var parent : Sprite2D = get_parent()

const shadow_drop : Vector2 = Vector2.DOWN * 5.0

func _ready() -> void:
	if texture == null : 
		texture = parent.texture
	modulate = Color.WHITE
	show_behind_parent = true
	scale = Vector2.ONE
	rotation = 0.0

func _process(delta: float) -> void:
	if !is_visible_in_tree(): return
	global_position = parent.global_position +  shadow_drop
