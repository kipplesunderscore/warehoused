extends BaseState
class_name MoveState

func get_dir() -> float:
	return configuration.direction_strength()

func enter() -> void:
	.enter()

func physics_process(delta: float) -> void:
	body.velocity.x = get_dir() * configuration.move_speed
	body.velocity.y = configuration.gravity * delta
	body.velocity = body.move_and_slide(body.velocity, Vector2.UP)
