extends CanvasLayer


@export_file("*.tscn") var main_menu: String
@export var options_scene: PackedScene
var options: Control


## Pause menu can't be opened if disabled
var enabled: bool = false

var music_bus: int
var sounds_bus: int
var voices_bus: int

var title: String:
	get:
		return %TitleLabel.text
	set(value):
		%TitleLabel.text = value

@onready var default_title: String = %TitleLabel.text


func _ready() -> void:
	hide()


func _unhandled_input(event: InputEvent) -> void:
	if not enabled and not visible:
		return
	
	# don't allow while paused
	if not visible and get_tree().paused:
		return
	
	if event.is_action_pressed("pause"):
		toggle()
		return
	
	# controller support
	if visible and not event is InputEventMouse and event.is_pressed():
		if not %ResumeButton.has_focus() and \
				not %RestartButton.has_focus() and \
				not %OptionsButton.has_focus() and \
				not %ExitButton.has_focus():
			%ResumeButton.grab_focus()


func toggle() -> void:
	visible = !visible
	get_tree().paused = visible
	
	if visible:
		Input.mouse_mode = Input.MOUSE_MODE_VISIBLE
		Events.game_paused.emit()
		
	else:
		Input.mouse_mode = Input.MOUSE_MODE_CAPTURED
		Events.game_unpaused.emit()


# play a sample when value is changed
func _on_music_slider_drag_started() -> void:
	%snd_sounds.stop()
	%snd_voices.stop()
	%snd_music.play()

func _on_sounds_slider_drag_started() -> void:
	%snd_music.stop()
	%snd_voices.stop()
	%snd_sounds.play()

func _on_voices_slider_drag_started() -> void:
	%snd_music.stop()
	%snd_sounds.stop()
	%snd_voices.play()


# close on click anywhere outside
func _on_fade_gui_input(event: InputEvent) -> void:
	if event is InputEventMouseButton:
		toggle()


func _on_resume_button_pressed() -> void:
	toggle()


func _on_restart_button_pressed() -> void:
	toggle()
	get_tree().reload_current_scene()


func _on_options_button_pressed() -> void:
	if not options:
		options = options_scene.instantiate()
		add_child(options)
	
	options.show()


func _on_exit_button_pressed() -> void:
	#TEST
	get_tree().quit()
	
	#TODO: Quit to main menu?
	#get_tree().change_scene_to_file(main_menu)
