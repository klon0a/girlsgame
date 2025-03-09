extends Control
class_name ColorSelector

signal new_color_chosen

@export var button_group : ButtonGroup
@onready var selection: Node2D = $Selection

@export var colors : Array[Color]


enum COLOR_OPTIONS {ORANGE, PURPLE, GREEN, CYAN, MAGENTA, YELLOW}
var _chosen_option : COLOR_OPTIONS
var chosen_option : COLOR_OPTIONS :
	get:
		return _chosen_option
	set(value):
		_chosen_option = value
		match value:
			ColorSelector.COLOR_OPTIONS.ORANGE:
				$ColorsParent/Orange.button_pressed = true
				color_chosen($ColorsParent/Orange)
			ColorSelector.COLOR_OPTIONS.PURPLE:
				$ColorsParent/Purple.button_pressed = true
				color_chosen($ColorsParent/Purple)
			ColorSelector.COLOR_OPTIONS.GREEN:
				$ColorsParent/Green.button_pressed = true
				color_chosen($ColorsParent/Green)
			ColorSelector.COLOR_OPTIONS.CYAN:
				$ColorsParent/Cyan.button_pressed = true
				color_chosen($ColorsParent/Cyan)
			ColorSelector.COLOR_OPTIONS.MAGENTA:
				$ColorsParent/Magenta.button_pressed = true
				color_chosen($ColorsParent/Magenta)
			ColorSelector.COLOR_OPTIONS.YELLOW:
				$ColorsParent/Yellow.button_pressed = true
				color_chosen($ColorsParent/Yellow)

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
			ColorSelector.COLOR_OPTIONS.MAGENTA:
				return colors[4]
			ColorSelector.COLOR_OPTIONS.YELLOW:
				return colors[5]
			_:
				return colors[4]


func _ready() -> void:
	for child in $ColorsParent.get_children():
		if child is Button:
			child.button_group = button_group
	
	button_group.pressed.connect(color_chosen)



func color_chosen(button : BaseButton):
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
		"Magenta":
			_chosen_option = COLOR_OPTIONS.MAGENTA
		"Yellow":
			_chosen_option = COLOR_OPTIONS.YELLOW
	
	emit_signal("new_color_chosen")
	pass
