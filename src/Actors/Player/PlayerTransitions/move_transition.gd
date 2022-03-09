extends BaseTransition
class_name PlayerMoveTransition

func _ready() -> void:
    state_node_string = "move"

func should_transition(body: Actor2D) -> bool:
    return body.is_on_floor() and (Input.is_action_pressed("left") or Input.is_action_pressed("right"))
