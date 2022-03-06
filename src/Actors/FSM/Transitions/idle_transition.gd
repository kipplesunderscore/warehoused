extends BaseTransition
class_name IdleTransition

func _ready() -> void:
    state_node_string = "idle"

func should_transition(body: Actor2D) -> bool:
    return body.velocity.is_equal_approx(Vector2.ZERO) and body.is_on_floor()
