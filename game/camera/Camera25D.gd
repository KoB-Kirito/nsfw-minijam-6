extends Camera3D

@export var target: Node3D = null
@export var smoothSpeed: float = 2

var cameraTarget: Node3D

func _ready():
	# find camera target within target node
	cameraTarget = target.find_child("CameraTarget")


func _physics_process(delta) -> void:
	# Smoothly move the camera to the offset away from the target
	# (and add noise offset)
	# lerp only in z (use only the z value of the cameraTarget position)
	self.position = lerp(self.position,
		Vector3(cameraTarget.global_position.x, self.position.y, self.position.z),
		smoothSpeed * delta)
