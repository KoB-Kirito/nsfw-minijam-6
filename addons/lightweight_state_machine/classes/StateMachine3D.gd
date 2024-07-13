@icon("StateMachine3D.svg")
class_name StateMachine3D
extends Node3D


signal state_changed(object: Node, old_state: State3D, new_state: State3D)

## Initial state entered on ready
@export var initial_state: State3D

var current_state: State3D
var last_state: State3D


func _ready() -> void:
	for node in get_states_recursive(self):
		node.state_machine = self
		node.process_mode = Node.PROCESS_MODE_DISABLED
	
	if initial_state != null:
		change_state(initial_state)


func change_state(new_state: State3D):
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


func get_states_recursive(node: Node, nodes: Array[State3D] = []) -> Array[State3D]:
	if node is State3D:
		nodes.push_back(node)
	for child in node.get_children():
		nodes = get_states_recursive(child, nodes)
	return nodes
