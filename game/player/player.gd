extends CharacterBody3D


@export_group("Movement")
@export var speed : float = 5.0
@export var smooth_speed: float = 10.0
@export var rotation_speed: float = 5.0

@export_group("Jump")
@export var jump_velocity: float = 4.5
@export var gravity: float = 9.8
## What the fuck does this do?
@export var fall_decay: float = 2.0

@export_group("Camera")
@export var camera_forward_distance: float = 2.0
@export var camera_forward_speed: float = 0.5
@export var camera_target_offset: Vector3 = Vector3(0, 2.25, 0)


var last_direction: Vector3 = Vector3.RIGHT
var camera_current_distance: float = 0


#HACK
@onready var animation_tree: AnimationTree = find_child("AnimationTree")


func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("jump"):
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * 2
	else:
		velocity.y = 0
	
	# Handle Jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		velocity.y = jump_velocity
	
	
	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "crouch", "jump")
	var direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
	
	if is_on_floor(): # don't walk while airborn
		velocity.x = lerp(velocity.x, direction.x * speed, smooth_speed * delta)
		velocity.z = lerp(velocity.z, direction.z * speed, smooth_speed * delta)
		
		# set animation blend based on speed
		animation_tree.set("parameters/IdleToRun/blend_position", velocity.length() / speed)
	else:
		velocity.x = lerp(velocity.x, direction.x * speed, smooth_speed * delta / fall_decay)
		velocity.z = lerp(velocity.z, direction.z * speed, smooth_speed * delta / fall_decay)
		# TODO: falling???
		animation_tree.set("parameters/IdleToRun/blend_position", 0)
	
	move_and_slide()
	
	
	# save last move direction
	if direction:
		last_direction = direction
		camera_current_distance = lerp(camera_current_distance, direction.x * camera_forward_distance, smooth_speed * delta * camera_forward_speed)
		%CameraTarget.global_position = global_position + camera_target_offset + Vector3.RIGHT * camera_current_distance
	
	# rotate player to face movement direction
	%Model.rotation.y = lerp_angle(%Model.rotation.y, atan2(last_direction.x, last_direction.z), rotation_speed * delta)
