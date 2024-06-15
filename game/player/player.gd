extends CharacterBody3D


@export var SPEED : float = 5
@export var SMOOTH_SPEED: float = 10
@export var ROTATION_SPEED: float = 5
@export var FALL_DECAY: float = 100
const JUMP_VELOCITY = 4.5
const CAMERA_FORWARD_DIST = 1.75

@onready var model: Node3D = $Model
@onready var cameraTaget: Node3D = $CameraTarget
@onready var animTree: AnimationTree = find_child("AnimationTree")
@onready var animPlayer: AnimationPlayer = find_child("AnimationPlayer")

var _active: bool = true
var direction: Vector3 = Vector3.ZERO
var lastDirection: Vector3 = Vector3.RIGHT
var cameraTargetOffset: Vector3 = Vector3(0, 2.25, 0)
var cameraCurrentDist: float = 0

var _footstepSound: AudioStream = preload("res://assets/audio/sounds/steps_floor.ogg")

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		if Input.is_action_pressed("up"):
			velocity.y -= gravity * delta
		else:
			velocity.y -= gravity * delta * 2
	else:
		velocity.y = 0

	# Handle Jump.
	if _active and Input.is_action_just_pressed("up") and is_on_floor():
		velocity.y = JUMP_VELOCITY

	if _active:
		# Get the input direction and handle the movement/deceleration.
		# As good practice, you should replace UI actions with custom gameplay actions.
		var input_dir = Input.get_vector("backward", "forward", "down", "up")
		direction = (transform.basis * Vector3(input_dir.x, 0, 0)).normalized()
		
	
	if is_on_floor(): # don't walk while airborn
		velocity.x = lerp(velocity.x, direction.x * SPEED, SMOOTH_SPEED * delta)
		velocity.z = lerp(velocity.z, direction.z * SPEED, SMOOTH_SPEED * delta)

		# set animation blend based on speed
		animTree.set("parameters/IdleToRun/blend_position", velocity.length() / SPEED)
	else:
		velocity.x = lerp(velocity.x, 0.0, SMOOTH_SPEED * delta / FALL_DECAY)
		velocity.z = lerp(velocity.z, 0.0, SMOOTH_SPEED * delta / FALL_DECAY)
		# TODO: falling???
		animTree.set("parameters/IdleToRun/blend_position", 0)


	move_and_slide()

	# save last move direction
	if direction:
		cameraCurrentDist = lerp(cameraCurrentDist, direction.x * CAMERA_FORWARD_DIST, SMOOTH_SPEED * delta * 0.5)
		cameraTaget.global_position = global_position + cameraTargetOffset + Vector3.RIGHT * cameraCurrentDist
		lastDirection = direction
	
	# rotate player to face movement direction
	model.rotation.y = lerp_angle(model.rotation.y, atan2(lastDirection.x, lastDirection.z), ROTATION_SPEED * delta)


func _on_console_activated():
	_active = false


func _on_console_deactivated():
	_active = true


#func _on_area_3d_body_entered(_body: Node3D) -> void:
	#TODO: Sound
	#var asPlayer = SoundManager.play_sound(_footstepSound, "SFX")
	#asPlayer.pitch_scale = random_pitch
