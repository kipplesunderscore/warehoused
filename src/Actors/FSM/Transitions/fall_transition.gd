extends BaseTransition
class_name FallTransition

func _ready() -> void:
    state_node_string = "fall"

func should_transition(body: Actor2D) -> bool:
    return not (body.velocity.y < 0 or body.is_on_floor())
