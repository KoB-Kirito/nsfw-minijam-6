extends State3D
## Running state


# just for auto-complete
@onready var _owner: Player = owner


func _physics_process(delta: float) -> void:
	if not _owner.is_on_floor():
		change_state(%Falling)
		return
	
	if Input.is_action_just_pressed("jump"):
		change_state(%Jumping)
		return
	
	# horizontal movement
	_owner.handle_default_horizontal_movement(delta)
	_owner.move_and_slide()
	
	# rotate model
	%Model.rotation.y = lerp_angle(%Model.rotation.y, atan2(_owner.last_direction.x, _owner.last_direction.z), _owner.rotation_speed * delta)
	
	# idle
	if is_zero_approx(_owner.velocity.x):
		change_state(%Idle)


func _process(delta: float) -> void:
	# set animation blend based on speed
	%AnimationTree.set("parameters/IdleToRun/blend_position", _owner.get_real_velocity().length() / _owner.maximum_speed)
