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
	
	var input_x := Input.get_axis("left", "right")
	if input_x > 0:
		# right
		_owner.last_direction = Vector3.RIGHT
		
		if _owner.velocity.x < 0:
			# de-accelerating toward 0
			_owner.velocity.x = move_toward(_owner.velocity.x, _owner.maximum_speed, _owner.de_acceleration * _owner.friction * delta)
			
		else:
			# accelerating
			_owner.velocity.x = move_toward(_owner.velocity.x, _owner.maximum_speed, _owner.acceleration * _owner.friction * delta)
		
	elif input_x < 0:
		# left
		_owner.last_direction = Vector3.LEFT
		
		if _owner.velocity.x > 0:
			# de-accelerating toward 0
			_owner.velocity.x = move_toward(_owner.velocity.x, -_owner.maximum_speed, _owner.de_acceleration * _owner.friction * delta)
			
		else:
			# accelerating
			_owner.velocity.x = move_toward(_owner.velocity.x, -_owner.maximum_speed, _owner.acceleration * _owner.friction * delta)
		
	else:
		# stop
		_owner.velocity.x = move_toward(_owner.velocity.x, 0, _owner.de_acceleration * _owner.friction * delta)
	
	_owner.move_and_slide()
	
	# rotate model
	%Model.rotation.y = lerp_angle(%Model.rotation.y, atan2(_owner.last_direction.x, _owner.last_direction.z), _owner.rotation_speed * delta)
	
	# idle
	if is_zero_approx(_owner.velocity.x):
		change_state(%Idle)


func _process(delta: float) -> void:
	# set animation blend based on speed
	%AnimationTree.set("parameters/IdleToRun/blend_position", _owner.get_real_velocity().length() / _owner.maximum_speed)
