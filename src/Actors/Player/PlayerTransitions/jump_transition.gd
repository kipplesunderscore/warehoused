extends BaseTransition
class_name PlayerJumpTransition

func _ready() -> void:
    state_node_string = "jump"

func should_transition(body: Actor2D) -> bool:
    return Input.is_action_just_pressed("jump")
