extends BaseState
class_name JumpState

func get_jump_gravity() -> float:
	var jump_time_to_peak = configuration.jump_time_to_peak
	return ((-2.0 * configuration.jump_height) / (jump_time_to_peak * jump_time_to_peak)) * -1.0

func get_dir() -> float:
	return configuration.direction_strength()

func enter() -> void:
	.enter()
	body.velocity.y = configuration.jump_velocity
	
func physics_process(delta: float) -> void:
	body.velocity.x = get_dir() * configuration.move_speed
	body.velocity.y += get_jump_gravity() * delta
	body.velocity = body.move_and_slide(body.velocity, Vector2.UP)
