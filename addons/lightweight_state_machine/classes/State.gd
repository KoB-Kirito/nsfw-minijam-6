@icon("State.svg")
class_name State
extends Node
## Base class for states without transform.
## For your unique state create a new node
## and add a script that extends this class.


## Get the state machine that manages this state
var state_machine: StateMachine
## Get the state that was active before this state
var last_state: State:
	get():
		return state_machine.last_state


## Override. Called when the state is entered.
func _enter_state() -> void:
	pass


## Override. Called when the state is exited.
func _exit_state() -> void:
	pass


## Call to change state.
func change_state(new_state: State) -> void:
	state_machine.change_state(new_state)
