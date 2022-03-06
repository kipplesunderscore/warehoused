extends Node

export (NodePath) var initial_state
export (NodePath) var configuration_node

var state_dictionary := {}

var current_state: BaseState

func transition_state(new_state: BaseState) -> void:
    if current_state:
        current_state.exit()
    
    current_state = new_state
    current_state.enter()

func init(body: Actor2D) -> void:
    for child in get_children():
        child.init(body)
        child.configuration = get_node(configuration_node)
        state_dictionary[child.state_name] = child
    transition_state(get_node(initial_state))
    
func physics_process(delta: float) -> void:
    current_state.physics_process(delta)
    
func process(delta: float) -> void:
    current_state.process(delta)

func get_state(state_string: String) -> BaseState:
    return state_dictionary.get(state_string, current_state)

func transition_process() -> void:
    var new_state = get_state(current_state.transition_process())
    if new_state and new_state != current_state:
        transition_state(new_state)
