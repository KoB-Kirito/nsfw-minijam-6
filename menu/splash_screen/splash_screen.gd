extends Control


@export_file("*.tscn") var next_scene: String

@export_group("Scene Transition")
@export var transition_duration: float = 1.0
@export var transition_color: Color = Color.BLACK

@export_group("Splash Transitions")
@export_subgroup("Fade In")
@export var fade_in_duration: float = 1.0
@export var fade_in_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var fade_in_ease: Tween.EaseType

@export_subgroup("Stay")
@export var stay_duration: float = 1.0

@export_subgroup("Fade Out")
@export var fade_out_duration: float = 1.0
@export var fade_out_transition: Tween.TransitionType = Tween.TransitionType.TRANS_QUAD
@export var fade_out_ease: Tween.EaseType = Tween.EASE_OUT


func _ready() -> void:
	var tween := create_tween()
	
	# godot
	tween.tween_property(%Fade, "modulate", Color.TRANSPARENT, fade_in_duration).set_trans(fade_in_transition).set_ease(fade_in_ease)
	tween.tween_interval(stay_duration)
	tween.tween_property(%Fade, "modulate", Color.WHITE, fade_out_duration).set_trans(fade_out_transition).set_ease(fade_out_ease)
	
	#TODO: Team splash, Best played with controller?, ...
	
	var transition_options := SceneTransition.Options.new(next_scene)
	transition_options.duration = transition_duration
	transition_options.color = transition_color
	
	tween.tween_callback(func(): SceneTransition.change_scene(transition_options))
