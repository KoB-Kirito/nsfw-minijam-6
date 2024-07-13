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
	
	_owner.move_and_slide()
