extends Node3D

@export var startX : float = 10
@export var maxAngle : float = 180
@export var radius : float = 10
@export var player : Node3D

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
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
