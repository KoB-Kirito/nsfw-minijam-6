extends State3D


@onready var _owner: Slime = owner

var direction: int = 0


func _ready() -> void:
	direction = _owner.starting_walking_direction


func _physics_process(delta: float) -> void:
	if not _owner.is_on_floor():
		_owner.velocity += _owner.get_gravity()
	
	if direction:
		# check right
		if %RayCastRight.is_colliding() or not %RayCastRightFloor.is_colliding():
			direction = 0
		
	else:
		# check left
		if %RayCastLeft.is_colliding() or not %RayCastLeftFloor.is_colliding():
			direction = 1
	
	if direction:
		# right
		_owner.velocity.x = _owner.speed
		
	else:
		# left
		_owner.velocity.x = - _owner.speed
	
	_owner.move_and_slide()
