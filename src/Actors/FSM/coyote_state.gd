extends BaseState
class_name CoyoteState

var coyote_start_time := 0.0
var coyote_time := false

func transition_process() -> String:
	for transition in transitions:
		if transition.state_node_string == "fall" and coyote_time:
			continue
		if transition.should_transition(body):
			return transition.state_node_string
	return ""
	
func enter() -> void:
	.enter()
	coyote_time = true
	coyote_start_time = OS.get_ticks_msec() / 1000.0
	pass
	
func get_dir() -> float:
	return configuration.direction_strength()
	
func physics_process(delta: float) -> void:
	if (OS.get_ticks_msec() / 1000.0) - coyote_start_time > configuration.coyote_duration:
		coyote_time = false
	if not coyote_time:
		body.velocity.y = 1
	body.velocity.x = get_dir() * configuration.move_speed
	body.velocity = body.move_and_slide(body.velocity, Vector2.UP)
