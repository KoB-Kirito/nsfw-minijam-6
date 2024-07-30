class_name Player
extends CharacterBody3D


@export_group("Movement")
## Maximum speed in m/s
@export_range(0.0, 16.0, 0.2) var maximum_speed: float = 8.0
## Acceleration in m/s (acceleration = maximum_speed -> 1 second to reach maximum_speed)
@export_range(0.0, 128.0, 0.5) var acceleration: float = 32.0
## De-acceleration in m/s (de-acceleration = maximum_speed -> 1 second to reach 0)
@export_range(0.0, 128.0, 0.5) var de_acceleration: float = 64.0
## Acceleration and de-acceleration are multiplied by friction
@export_range(0.0, 2.0, 0.1) var friction: float = 1.0

@export_group("Jump")
## Jump impuls strength in m/s
@export_range(0.0, 32.0, 0.5) var jump_velocity: float = 16.0
## Gravity is multiplied by this value while rising
@export_range(0.0, 16.0, 0.5) var gravity_multiplyer_rise: float = 6.0
## Gravity multiplyer used while rising and holding jump
@export_range(0.0, 16.0, 0.5) var gravity_multiplyer_rise_jumping: float = 4.0
## Gravity is multiplied by this value while falling
@export_range(0.0, 16.0, 0.5) var gravity_multiplyer_fall: float = 10.0
## Gravity multiplyer used while falling and holding jump
@export_range(0.0, 16.0, 0.5) var gravity_multiplyer_fall_jumping: float = 8.0
## Gravity multiplied by this is the maximum falling speed
@export_range(0.0, 4.0, 0.2) var maximum_falling_speed_multiplyer: float = 2.0

@export_group("Animation")
## How fast the model rotates when changing input_x
@export var rotation_speed: float = 20.0

@export_group("Camera")
## How far the camera moves in the input_x the player moves in m
@export_range(0.0, 16.0, 0.5) var camera_look_ahead_distance: float = 8.0
@export_range(0.0, 16.0, 0.5) var camera_look_ahead_speed: float = 2.0
@export var cam_follows_player: bool = true


var last_direction: Vector3 = Vector3.RIGHT


func handle_default_horizontal_movement(delta: float) -> void:
	var input_x := Input.get_axis("left", "right")
	if input_x > 0:
		# right
		last_direction = Vector3.RIGHT
		
		if velocity.x < 0:
			# de-accelerating toward 0
			velocity.x = move_toward(velocity.x, maximum_speed, de_acceleration * friction * delta)
			
		else:
			# accelerating
			velocity.x = move_toward(velocity.x, maximum_speed, acceleration * friction * delta)
		
	elif input_x < 0:
		# left
		last_direction = Vector3.LEFT
		
		if velocity.x > 0:
			# de-accelerating toward 0
			velocity.x = move_toward(velocity.x, -maximum_speed, de_acceleration * friction * delta)
			
		else:
			# accelerating
			velocity.x = move_toward(velocity.x, -maximum_speed, acceleration * friction * delta)
		
	else:
		# stop
		velocity.x = move_toward(velocity.x, 0, de_acceleration * friction * delta)


# Debug
func _on_state_machine_3d_state_changed(object: Node, old_state: State3D, new_state: State3D) -> void:
	#print("Player changed state from ", old_state.name if old_state else "null", " to ", new_state.name)
	%Debug.text = new_state.name


func _on_health_changed() -> void:
	print_debug("health changed: ", %HealthComponent.health)
