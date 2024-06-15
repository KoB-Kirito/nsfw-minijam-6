extends Control


## Scene that is loaded when start button is pressed
@export_file("*.tscn") var start_scene: String
@export_group("Transition")
@export var transition_duration: float = 1.0
@export var transition_color: Color = Color.BLACK

@export_group("BGM")
@export var bgm: AudioStream
@export var volume_db: float = 0.0


func _ready() -> void:
	if bgm:
		Bgm.fade_to(bgm, volume_db, 0.0)


func _on_start_button_pressed() -> void:
	var transition_options := SceneTransition.Options.new(start_scene)
	transition_options.duration = transition_duration
	transition_options.color = transition_color
	
	SceneTransition.change_scene(transition_options)



func _on_options_button_pressed() -> void:
	pass # Replace with function body.


func _on_exit_button_pressed() -> void:
	get_tree().quit()
	#TODO: Does nothing on web