extends Control
class_name Closet

@onready var closet_scroll: ClosetScroll = $ClosetInside/ClosetScroll
@onready var closet_shelves: ClosetShelves = $ClosetInside/ClosetShelves
@onready var color_buttons: ColorSelector = $ColorButtons

var tops_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA
var bottoms_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA
var shoes_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA
var accessories_color : ColorSelector.COLOR_OPTIONS = ColorSelector.COLOR_OPTIONS.MAGENTA

@export var top_material : Material
@export var bottom_material : Material
@export var accessory_material : Material
@export var shoe_material : Material

@export var tops_list : Array[PackedScene]
@export var bottoms_list : Array[PackedScene]
@export var fulls_list : Array[PackedScene]

@export var shoes_list : Array[PackedScene]

@export var accessories_list : Array[PackedScene]

static var inside_rect : Rect2

enum CATEGORY {TOPS, BOTTOMS, SHOES, ACCESSORIES}
var _category : CATEGORY
var current_category : CATEGORY :
	get:
		return _category
	set(value): 
		_category = value
		$ClosetTitle/Accessories.visible = false
		$ClosetTitle/Bottoms.visible = false
		$ClosetTitle/Tops.visible = false
		$ClosetTitle/Shoes.visible = false
		
		const deselected_target_scale = Vector2.ONE * 0.85
		const selected_target_scale = Vector2.ONE * 1.1
		shoes.target_scale = deselected_target_scale
		bottoms.target_scale = deselected_target_scale
		tops.target_scale = deselected_target_scale
		accessories.target_scale = deselected_target_scale

		# make the right ones visible
		match _category:
			Closet.CATEGORY.TOPS, Closet.CATEGORY.BOTTOMS:
				closet_scroll.visible = true
				closet_shelves.visible = false
				pass
			
			Closet.CATEGORY.SHOES, Closet.CATEGORY.ACCESSORIES:
				closet_scroll.visible = false
				closet_shelves.visible = true
				pass
		
		match _category:
			Closet.CATEGORY.TOPS:
				var combined_tops_and_fulls = tops_list.duplicate() 
				combined_tops_and_fulls.append_array(fulls_list.duplicate())
				closet_scroll.populate_coathangers(combined_tops_and_fulls, top_material)
				
				$ClosetTitle/Tops.visible = true
				tops.target_scale = selected_target_scale
				
			Closet.CATEGORY.BOTTOMS:
				var combined_bottoms_and_fulls = bottoms_list.duplicate() 
				combined_bottoms_and_fulls.append_array(fulls_list.duplicate())
				closet_scroll.populate_coathangers(combined_bottoms_and_fulls, bottom_material)
				
				$ClosetTitle/Bottoms.visible = true
				bottoms.target_scale = selected_target_scale
			
			Closet.CATEGORY.SHOES:
				closet_shelves.populate_shelves(shoes_list, shoe_material)
				$ClosetTitle/Shoes.visible = true
				shoes.target_scale = selected_target_scale
				
			Closet.CATEGORY.ACCESSORIES:
				closet_shelves.populate_shelves(accessories_list, accessory_material)
				$ClosetTitle/Accessories.visible = true
				accessories.target_scale = selected_target_scale

func _ready() -> void:
	inside_rect = $ClosetInside.get_global_rect()
	_on_tops_category_pressed()
	_on_toggle_music_pressed() # cycle it by 1 (sideeffect) and update the stream paused parameters

@onready var drummy: AudioStreamPlayer = $"UI Sounds/Drummy"
func play_drummy():
	drummy.pitch_scale = randf_range(0.85, 1.15)
	drummy.play()

@onready var music: ScaleTargeter = $ButtonScalers/Music
@onready var eyes: ScaleTargeter = $ButtonScalers/Eyes
@onready var eye_color: ScaleTargeter = $ButtonScalers/EyeColor
@onready var tops: ScaleTargeter = $ButtonScalers/Tops
@onready var shoes: ScaleTargeter = $ButtonScalers/Shoes
@onready var accessories: ScaleTargeter = $ButtonScalers/Accessories
@onready var coat: ScaleTargeter = $ButtonScalers/Coat
@onready var bottoms: ScaleTargeter = $ButtonScalers/Bottoms


func _on_tops_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.TOPS
	color_buttons.chosen_option = tops_color
	
	tops.scale_speed += Vector2.ONE * 3.0
	pass # Replace with function body.


func _on_bottoms_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.BOTTOMS
	color_buttons.chosen_option = bottoms_color
	
	bottoms.scale_speed += Vector2.ONE * 3.0
	pass # Replace with function body.


func _on_shoes_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.SHOES
	color_buttons.chosen_option = shoes_color
	
	shoes.scale_speed += Vector2.ONE * 3.0
	pass # Replace with function body.


func _on_accessories_category_pressed() -> void:
	play_drummy()
	current_category = CATEGORY.ACCESSORIES
	color_buttons.chosen_option = accessories_color
	
	accessories.scale_speed += Vector2.ONE * 3.0
	pass # Replace with function body.


func _on_color_buttons_new_color_chosen() -> void:
	var new_color = color_buttons.chosen_option
	match _category:
		Closet.CATEGORY.TOPS:
			tops_color = new_color
			top_material.set_shader_parameter("to", color_buttons.chosen_color)
			top_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
		
		Closet.CATEGORY.BOTTOMS:
			bottoms_color = new_color
			bottom_material.set_shader_parameter("to", color_buttons.chosen_color)
			bottom_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
		
		Closet.CATEGORY.SHOES:
			shoes_color = new_color
			shoe_material.set_shader_parameter("to", color_buttons.chosen_color)
			shoe_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
		
		Closet.CATEGORY.ACCESSORIES:
			accessories_color = new_color
			accessory_material.set_shader_parameter("to", color_buttons.chosen_color)
			accessory_material.set_shader_parameter("greyscale", color_buttons.chosen_option == ColorSelector.COLOR_OPTIONS.WHITE)
	pass # Replace with function body.

@onready var rising: AudioStreamPlayer = $"UI Sounds/Rising"
func _on_cycle_coat_pressed() -> void:
	rising.play()
	%Kitty.cycle_kitty_color()
	coat.scale_speed += Vector2.ONE * 4.0
	coat.scale *= 0.9
	pass # Replace with function body.


func _on_cycle_eyes_pressed() -> void:
	rising.play()
	%Kitty.cycle_eyes()
	eyes.scale_speed += Vector2.ONE * 4.0
	eyes.scale *= 0.9
	pass # Replace with function body.


func _on_cycle_eye_color_pressed() -> void:
	pass # Replace with function body.

@onready var kittys_clawset_song_1: AudioStreamPlayer = $"../Music/KittysClawsetSong1"
@onready var kittys_clawset_song_2: AudioStreamPlayer = $"../Music/KittysClawsetSong2"
var music_setting : int = 0 
func _on_toggle_music_pressed() -> void:
	music_setting = (music_setting + 1)%3
	kittys_clawset_song_1.stream_paused = music_setting != 2
	kittys_clawset_song_2.stream_paused = music_setting != 1
	music.scale_speed += Vector2(sign(music.scale.x), sign(music.scale.y)) * 2.0
	match music_setting:
		0:
			music.target_scale = Vector2.ONE * 0.5
		1:
			music.target_scale = Vector2(1.0, 1.0)
		2: 
			music.target_scale = Vector2(-1.0, 1.0)
	pass # Replace with function body.
