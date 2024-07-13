@icon("StateMachine.svg")
class_name StateMachine
extends Node
## Finite State Machine
## Ensures that only one state is active at a time.
## Finds all states recursivly.


signal state_changed(object: Node, old_state: State, new_state: State)

## Initial state entered on ready
@export var initial_state: State

var current_state: State
var last_state: State


func _ready() -> void:
	for node in get_states_recursive(self):
		node.state_machine = self
		node.process_mode = Node.PROCESS_MODE_DISABLED
	
	if initial_state != null:
		change_state(initial_state)


func change_state(new_state: State):
	if new_state == null:
		push_error("Tried to change to state that is null")
		return
	
	if current_state != null:
		current_state.process_mode = Node.PROCESS_MODE_DISABLED
		current_state._exit_state()
	
	last_state = current_state
	current_state = new_state
	
	current_state._enter_state()
	current_state.process_mode = Node.PROCESS_MODE_INHERIT
	
	state_changed.emit(owner, last_state, current_state)
	# If you use a global event bus, you can hookup it here
	# Events.state_changed.emit(owner, last_state, current_state)


func get_states_recursive(node: Node, nodes: Array[State] = []) -> Array[State]:
	if node is State:
		nodes.push_back(node)
	for child in node.get_children():
		nodes = get_states_recursive(child, nodes)
	return nodes
