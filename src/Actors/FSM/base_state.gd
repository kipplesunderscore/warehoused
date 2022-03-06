extends Node
class_name BaseState

var body: Actor2D
var transitions := []
var configuration : Node

export (String) var state_name = "unknown"

func init(b: Actor2D) -> void:
    body = b
    for child in get_children():
        transitions.push_back(child)

func enter() -> void:
    pass
    
func exit() -> void:
    pass
    
func transition_process() -> String:
    for transition in transitions:
        if transition.should_transition(body):
            return transition.state_node_string
    return ""
    
func physics_process(delta: float) -> void:
    pass
    
func process(delta: float) -> void:
    pass
    
func input(event: InputEvent) -> void:
    pass
