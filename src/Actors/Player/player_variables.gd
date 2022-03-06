extends Node

export var jump_height := 300.0
export var jump_time_to_peak := 0.3
export var jump_time_to_descent := 0.2
export var move_speed := 500.0
export var coyote_duration := 0.048

onready var jump_velocity := -((2.0 * jump_height) / jump_time_to_peak)
onready var jump_gravity := ((2.0 * jump_height) / (jump_time_to_peak * jump_time_to_peak))
onready var fall_gravity := ((2.0 * jump_height) / (jump_time_to_descent * jump_time_to_descent))
onready var gravity := fall_gravity

var direction = 1

func facing_direction() -> int:
	if Input.is_action_pressed("left"):
		direction = -1
	if Input.is_action_pressed("right"):
		direction = 1
	return direction

func direction_strength() -> float:
	return Input.get_action_strength("right") - Input.get_action_strength("left")
