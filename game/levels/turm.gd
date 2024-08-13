extends Node3D


@export var startX : float = 10
@export var maxAngle : float = 180
@export var radius : float = 10

var player: Player


func _ready() -> void:
	player = get_tree().get_first_node_in_group("player")


func _physics_process(delta: float) -> void:
	var endX = startX + (radius * PI * maxAngle / 180)
	if (player.global_position.x <= startX):
		global_position.x = startX
		global_rotation.y = 0
		return
	if (player.global_position.x >= endX):
		global_position.x = endX
		global_rotation_degrees.y = -maxAngle
		return
	global_position.x = player.global_position.x
	global_rotation_degrees.y = (player.global_position.x - startX) / (endX - startX) * -maxAngle
