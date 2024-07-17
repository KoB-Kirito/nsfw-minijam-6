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
	
	# horizontal movement
	_owner.handle_default_horizontal_movement(delta)
	
	_owner.move_and_slide()
