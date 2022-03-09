extends BaseTransition
class_name PlayerBufferedJumpTransition

export (float) var buffer_duration = 0.096

var input_just_press_time := 0.0

func _ready() -> void:
    state_node_string = "jump"

func should_transition(body: Actor2D) -> bool:
    if Input.is_action_just_pressed("jump"):
        input_just_press_time = OS.get_ticks_msec() / 1000.0
    
    if body.is_on_floor() and Input.is_action_pressed("jump"):
        if OS.get_ticks_msec() / 1000.0 - input_just_press_time < buffer_duration:
            return true
        
    return false
