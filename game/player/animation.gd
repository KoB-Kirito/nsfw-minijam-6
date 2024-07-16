class_name PlayerAnimation
extends AnimationTree


enum ANIMATIONS {
	GROUNDED,
	JUMPING,
	FALLING,
}

func set_state(state: ANIMATIONS) -> void:
	match state:
		ANIMATIONS.GROUNDED:
			set("parameters/state/transition_request", "grounded")
		
		ANIMATIONS.JUMPING:
			set("parameters/state/transition_request", "jumping")
		
		ANIMATIONS.FALLING:
			set("parameters/state/transition_request", "falling")
