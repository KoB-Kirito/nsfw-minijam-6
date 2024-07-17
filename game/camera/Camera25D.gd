extends Camera3D
## Main game camera for 2.5D games.
## - Follows the player
## - Looks ahead
## - y movement only while landed


## Target
@export var player: Player
@export_range(0.0, 60.0, 1.0) var follow_speed: float = 2.0
## Distance in meters that the camera will look ahead in moved direction
@export var look_ahead: float = 3.0

var offset: Vector3
var last_y: float


func _ready() -> void:
	assert(player, "Player is not set")
	
	offset = global_position - player.global_position


func _physics_process(delta: float) -> void:
	var target_position := player.global_position
	
	if player.is_on_floor():
		last_y = player.global_position.y
		
	else:
		# keep y while airborne
		target_position.y = last_y
	
	if player.last_direction == Vector3.LEFT:
		target_position.x -= look_ahead
	elif player.last_direction == Vector3.RIGHT:
		target_position.x += look_ahead
	
	target_position += offset
	
	global_position = global_position.lerp(target_position, follow_speed * delta)
