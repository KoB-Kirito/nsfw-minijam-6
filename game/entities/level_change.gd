class_name LevelChange
extends Area3D


## Level will change to provided level_path when emitted
signal change_level

## Level that will be loaded when triggered
@export_file("*.tscn") var level_path: String


func _ready() -> void:
	body_entered.connect(on_body_entered)
	print_debug("connected")


func on_body_entered(body: Node3D) -> void:
	if body is Player:
		print_debug("player entered")
		change_level.emit()
