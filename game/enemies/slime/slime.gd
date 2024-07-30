extends CharacterBody3D
class_name Slime


@export_enum("Left", "Right") var starting_walking_direction: int = 0
@export var speed: float = 2.0

@export var damage: int = 1


# state machine debug
func _on_state_machine_3d_state_changed(object: Node, old_state: State3D, new_state: State3D) -> void:
	%DebugLabel.text = new_state.name
