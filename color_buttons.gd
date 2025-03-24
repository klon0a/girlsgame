extends Control
class_name ColorSelector

signal new_color_chosen

@export var button_group : ButtonGroup
@onready var selection: Node2D = $Selection
@onready var selection_scale: ScaleTargeter = $SelectionScale

@export var colors : Array[Color]


enum COLOR_OPTIONS {ORANGE, PURPLE, GREEN, CYAN, WHITE, MAGENTA, YELLOW, BLACK}
var _chosen_option : COLOR_OPTIONS
var chosen_option : COLOR_OPTIONS :
	get:
		return _chosen_option
	set(value):
		_chosen_option = value
		match value:
			ColorSelector.COLOR_OPTIONS.ORANGE:
				skip_color_sound = true
				$ColorsParent/Orange.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Orange)
			ColorSelector.COLOR_OPTIONS.PURPLE:
				skip_color_sound = true
				$ColorsParent/Purple.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Purple)
			ColorSelector.COLOR_OPTIONS.GREEN:
				skip_color_sound = true
				$ColorsParent/Green.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Green)
			ColorSelector.COLOR_OPTIONS.CYAN:
				skip_color_sound = true
				$ColorsParent/Cyan.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Cyan)
			ColorSelector.COLOR_OPTIONS.WHITE:
				skip_color_sound = true
				$ColorsParent/White.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/White)
			ColorSelector.COLOR_OPTIONS.MAGENTA:
				skip_color_sound = true
				$ColorsParent/Magenta.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Magenta)
			ColorSelector.COLOR_OPTIONS.YELLOW:
				skip_color_sound = true
				$ColorsParent/Yellow.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Yellow)
			ColorSelector.COLOR_OPTIONS.BLACK:
				skip_color_sound = true
				$ColorsParent/Black.button_pressed = true
				skip_color_sound = true
				color_chosen($ColorsParent/Black)

var chosen_color : Color :
	get:
		match _chosen_option:
			ColorSelector.COLOR_OPTIONS.ORANGE:
				return colors[0]
			ColorSelector.COLOR_OPTIONS.PURPLE:
				return colors[1]
			ColorSelector.COLOR_OPTIONS.GREEN:
				return colors[2]
			ColorSelector.COLOR_OPTIONS.CYAN:
				return colors[3]
			ColorSelector.COLOR_OPTIONS.WHITE:
				return colors[4]
			ColorSelector.COLOR_OPTIONS.MAGENTA:
				return colors[5]
			ColorSelector.COLOR_OPTIONS.YELLOW:
				return colors[6]
			ColorSelector.COLOR_OPTIONS.BLACK:
				return colors[7]
			_:
				return colors[5]


func _ready() -> void:
	for child in $ColorsParent.get_children():
		if child is Button:
			child.button_group = button_group
	
	button_group.pressed.connect(color_chosen)
	selection_scale.target_scale = Vector2.ONE * 0.315


@onready var wui_wu: AudioStreamPlayer = $"WuiWu"

var skip_color_sound = false
func color_chosen(button : BaseButton):
	if skip_color_sound: # this is a bodge
		skip_color_sound = false
	else: 
		wui_wu.pitch_scale = randf_range(0.85, 1.15)
		wui_wu.play()
	
	selection_scale.scale = 0.7 * selection_scale.target_scale
	selection_scale.scale_speed += Vector2.ONE * 2.0
	
	selection.global_position = button.global_position
	match button.name:
		"Orange":
			_chosen_option = COLOR_OPTIONS.ORANGE
		"Purple":
			_chosen_option = COLOR_OPTIONS.PURPLE
		"Green":
			_chosen_option = COLOR_OPTIONS.GREEN
		"Cyan":
			_chosen_option = COLOR_OPTIONS.CYAN
		"White":
			_chosen_option = COLOR_OPTIONS.WHITE
		"Magenta":
			_chosen_option = COLOR_OPTIONS.MAGENTA
		"Yellow":
			_chosen_option = COLOR_OPTIONS.YELLOW
		"Black":
			_chosen_option = COLOR_OPTIONS.BLACK
	
	emit_signal("new_color_chosen")
	pass
