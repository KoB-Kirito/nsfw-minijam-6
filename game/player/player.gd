extends CharacterBody3D


## Set camera that should be moved by the player script
@export var camera: Camera3D

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
var camera_current_distance: float = 0
var cameraTarget: Node3D

@onready var camera_offset: Vector3 = abs(global_position - camera.global_position)

#HACK
@onready var animation_tree: AnimationTree = find_child("AnimationTree")

func _init() -> void:
	cameraTarget = find_child("CameraTarget")


func _physics_process(delta):
	# apply gravity
	if not is_on_floor():
		if Input.is_action_pressed("jump"):
			if velocity.y < 0:
				# falling
				velocity += get_gravity() * gravity_multiplyer_fall_jumping * delta
				
			else:
				# rising
				velocity += get_gravity() * gravity_multiplyer_rise_jumping * delta
			
		else:
			if velocity.y < 0:
				# falling
				velocity += get_gravity() * gravity_multiplyer_fall * delta
				
			else:
				# rising
				velocity += get_gravity() * gravity_multiplyer_rise * delta
		
		# cap falling speed
		if velocity.y < get_gravity().y * maximum_falling_speed_multiplyer:
			velocity.y = get_gravity().y * maximum_falling_speed_multiplyer
	
	
	# handle jump
	if Input.is_action_just_pressed("jump"):# and is_on_floor(): #TEST
		velocity.y = jump_velocity
	
	
	# handle movement
	var input_x := Input.get_axis("left", "right")
	if input_x > 0:
		# right
		if velocity.x < 0:
			# de-accelerating toward 0
			velocity.x = move_toward(velocity.x, maximum_speed, de_acceleration * friction * delta)
			
		else:
			# accelerating
			velocity.x = move_toward(velocity.x, maximum_speed, acceleration * friction * delta)
		
	elif input_x < 0:
		# left
		if velocity.x > 0:
			# de-accelerating toward 0
			velocity.x = move_toward(velocity.x, -maximum_speed, de_acceleration * friction * delta)
			
		else:
			# accelerating
			velocity.x = move_toward(velocity.x, -maximum_speed, acceleration * friction * delta)
		
	else:
		# stop
		velocity.x = move_toward(velocity.x, 0, de_acceleration * friction * delta)
	
	move_and_slide()
	
	
	# animation
	if is_on_floor():
		# set animation blend based on speed
		animation_tree.set("parameters/IdleToRun/blend_position", get_real_velocity().length() / maximum_speed)
		
	else:
		#TODO: falling???
		animation_tree.set("parameters/IdleToRun/blend_position", 0)
	
	# rotate player to face movement direction
	if input_x < -0.01:
		last_direction = Vector3.LEFT
		
	elif input_x > 0.01:
		last_direction = Vector3.RIGHT
	
	%Model.rotation.y = lerp_angle(%Model.rotation.y, atan2(last_direction.x, last_direction.z), rotation_speed * delta)
	
	
	# camera
	camera_current_distance = lerp(camera_current_distance, last_direction.x * camera_look_ahead_distance, camera_look_ahead_speed * delta)
	%CameraTarget.global_position = global_position + Vector3.RIGHT * camera_current_distance


func _on_area_3d_area_entered(area: Area3D) -> void:
	var pos: Node3D = area.find_child("Pos")
	print("Kamerabereich: %s" % [pos])
	cameraTarget.global_position = pos.global_position
	#cameraTarget.global_rotation = pos.global_rotation
	cam_follows_player = false


func _on_area_3d_area_exited(area: Area3D) -> void:
	cameraTarget.global_position = global_position
	cam_follows_player = true
