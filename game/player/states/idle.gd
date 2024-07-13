extends State3D
## Idle state


# just for auto-complete
@onready var _owner: Player = owner


func _enter_state() -> void:
	# play idle animation
	%AnimationTree.set("parameters/IdleToRun/blend_position", 0)
	
	# play additional idle animation after some time
	%IdleAnimationTimer.start()


func _exit_state() -> void:
	%IdleAnimationTimer.stop()


func _physics_process(delta) -> void:
	# falling
	if not _owner.is_on_floor():
		change_state(%Falling)
		return
	
	# jumping
	if Input.is_action_just_pressed("jump"):# and is_on_floor(): #TEST #TODO
		change_state(%Jumping)
		return
	
	# moving
	var input_x := Input.get_axis("left", "right")
	if not is_zero_approx(_owner.velocity.x) or not is_zero_approx(input_x):
		change_state(%Running)
		return


func _on_idle_animation_timer_timeout() -> void:
	#TODO: Play idle animation
	print_debug("Would play idle animation now..")
