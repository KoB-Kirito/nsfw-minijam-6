extends State3D
## Falling state


# just for auto-complete
@onready var _owner: Player = owner


# Called when state is entered.
func _enter_state() -> void:
	#TODO: Play falling animation
	pass


# Called when state is exited.
func _exit_state() -> void:
	pass


func _physics_process(delta: float) -> void:
	# landed
	if _owner.is_on_floor():
		change_state(%Idle)
		return
	
	# holding jump alters falling speed
	if Input.is_action_pressed("jump"):
		_owner.velocity += _owner.get_gravity() * _owner.gravity_multiplyer_fall_jumping * delta
		
	else:
		_owner.velocity += _owner.get_gravity() * _owner.gravity_multiplyer_fall * delta
	
	# cap falling speed
	if _owner.velocity.y < _owner.get_gravity().y * _owner.maximum_falling_speed_multiplyer:
		_owner.velocity.y = _owner.get_gravity().y * _owner.maximum_falling_speed_multiplyer
	
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
