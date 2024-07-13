@tool
extends EditorPlugin


func _enter_tree() -> void:
	add_custom_type("StateMachine", "Node", preload("classes/StateMachine.gd"), preload("classes/StateMachine.svg"))
	add_custom_type("StateMachine2D", "Node2D", preload("classes/StateMachine2D.gd"), preload("classes/StateMachine2D.svg"))
	add_custom_type("StateMachine3D", "Node3D", preload("classes/StateMachine3D.gd"), preload("classes/StateMachine3D.svg"))
	#pass


func _exit_tree() -> void:
	remove_custom_type("StateMachine")
	remove_custom_type("StateMachine2D")
	remove_custom_type("StateMachine3D")
	#pass
