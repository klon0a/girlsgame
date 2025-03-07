
extends Node2D

var noise = FastNoiseLite.new()
var time = 0.0
@export var scale_wobble : Vector2 = Vector2.ONE * 0.1
@export var scale_speed : float = 0.25
@export var pos_wobble : Vector2 = Vector2.ONE * 10.0
@export var pos_speed : float = 0.5
@export var rot_wobble : float = 0.05
@export var rot_speed : float = 0.5
@onready var def_scale = scale
@onready var def_pos = position


func _ready():
	randomize()
	noise.seed = randi()
	noise.fractal_octaves = 3
	noise.frequency = 0.1
	noise.fractal_lacunarity = 0.7



func _process(delta):
	time += delta
	scale.x = def_scale.x * (1.0 + noise.get_noise_2d(time * scale_speed, 0) * scale_wobble.x)
	scale.y = def_scale.y * (1.0 + noise.get_noise_2d(0, time * scale_speed) * scale_wobble.y)
	
	position.x = def_pos.x + noise.get_noise_2d(time * pos_speed, 100) * pos_wobble.x
	position.y = def_pos.y + noise.get_noise_2d(100, time * pos_speed) * pos_wobble.y
	
	rotation = noise.get_noise_2d(200, time * rot_speed) * rot_wobble
	pass
