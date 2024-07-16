extends State3D


# just for auto-complete
@onready var _owner: Player = owner


func _enter_state() -> void:
	# jump
	_owner.velocity.y = _owner.jump_velocity
	
	#TODO: play jump animation
	%AnimationTree.set("parameters/IdleToRun/blend_position", 0.0)
	


func _physics_process(delta: float) -> void:
	# falling
	if _owner.velocity.y <= 0:
		change_state(%Falling)
		return
	
	# holding jump alters jump height
	if Input.is_action_pressed("jump"):
		_owner.velocity += _owner.get_gravity() * _owner.gravity_multiplyer_rise_jumping * delta
		
	else:
		_owner.velocity += _owner.get_gravity() * _owner.gravity_multiplyer_rise * delta
	
	# vertical movement
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
