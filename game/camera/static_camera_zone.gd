@tool
extends Camera3D
## Moves the camera to the position of this camera
## while the player is inside the area defindes by
## the collision shapes added under this node.


@export var transition_duration: float = 2.0
@export var transition: Tween.TransitionType = Tween.TRANS_CUBIC

var original_transform: Transform3D


func _ready() -> void:
	if Engine.is_editor_hint():
		return
	
	original_transform = global_transform
	
	var area: Area3D
	for child in get_children():
		if child is Area3D:
			area = child
			break
	
	assert(area, "StaticCameraZone has no area")
	
	area.top_level = true
	area.body_entered.connect(on_trigger_area_body_entered)
	area.body_exited.connect(on_trigger_area_body_exited)


func on_trigger_area_body_entered(body: Node3D) -> void:
	if body is not Player:
		return
	
	#print_debug("Player entered")
	
	# move camera to current camera, tween from there
	global_transform = get_viewport().get_camera_3d().global_transform
	
	var tween = create_tween().set_ease(Tween.EASE_OUT).set_trans(transition)
	tween.tween_property(self, "global_transform", original_transform, transition_duration)
	
	self.make_current()


func on_trigger_area_body_exited(body: Node3D) -> void:
	if body is not Player:
		return
	
	#print_debug("Player left")
	
	# let the player camera lerp do the rest
	var player_camera = get_tree().get_first_node_in_group("player_camera")
	if player_camera:
		player_camera.global_transform = global_transform
	else:
		push_error("player_camera not found")
	
	self.clear_current()


#region Editor-Only
func _get_configuration_warnings() -> PackedStringArray:
	var warnings: PackedStringArray = []
	
	# check if node has a collision shape
	var has_area: bool = false
	for child in get_children():
		if child is Area3D:
			if has_area:
				warnings.append("Found multiple Area3D. StaticCameraZone will only use the first area.\n" +
								"You can add multiple CollisionShapes to one area if needed.")
				break
				
			else:
				has_area = true
	
	if not has_area:
		warnings.append("Add a Area3D to define the area that triggers this camera.\n" +
						"The camera is active while the player is inside that area.")
	
	#TODO: Check if area has right collision mask
	
	return warnings

func _notification(what: int) -> void:
	match what:
		NOTIFICATION_CHILD_ORDER_CHANGED:
			update_configuration_warnings()
#endregion
