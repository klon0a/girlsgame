extends Node2D
class_name SceneSwitcher

@export var gameplay_background: Node2D
@export var credits_background: Node2D
@export var closet: Node2D
#@export var kittys_clawset_title: Sprite2D
#@export var kitty: Kitty
@export var confirmation: Node2D
@export var UI : Closet
#@export var kitty_gameplay : Marker2D
#@export var kitty_credits : Marker2D

func _ready() -> void:
	set_gameplay_scene()
	#set_credits_scene()

func set_gameplay_scene():
	gameplay_background.visible = true
	credits_background.visible = false
	closet.visible = true
	UI.visible = true
	#kittys_clawset_title.visible = true
	#kitty.global_position = kitty_gameplay.global_position
	pass

func set_credits_scene():
	UI.visible = false
	closet.visible = false
	credits_background.visible = true
	gameplay_background.visible = false
	#kittys_clawset_title.visible = false
	#kitty.global_position = kitty_credits.global_position
	pass
