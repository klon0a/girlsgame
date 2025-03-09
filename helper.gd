extends Node2D
class_name Interpolator

static func good_lerp(source, target, smoothing, delta : float) -> float:
	return lerp(source, target, 1 - pow(smoothing, delta))

static func good_lerp_vector(source, target : Vector2, smoothing, delta : float) -> Vector2:
	return lerp(source, target, 1 - pow(smoothing, delta))

static func spring_speed(prev_speed, source, target, stiffness, enthusiasm, delta) -> float:
	var _target_speed = (target - source) * stiffness
	return good_lerp(prev_speed, _target_speed, enthusiasm, delta)

static func spring_speed_vector(prev_speed, source, target : Vector2, stiffness, enthusiasm, delta) -> Vector2:
	var _target_speed = (target - source) * stiffness
	return good_lerp_vector(prev_speed, _target_speed, enthusiasm, delta)
