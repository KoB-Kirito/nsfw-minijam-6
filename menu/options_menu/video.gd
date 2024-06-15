extends TabBar


const WINDOW_MODES = [
		"Fullscreen",
		"Borderless Fullscreen",
		"Windowed",
]

const RESOLUTIONS = {
		"640 x 480"   : Vector2i(640, 480),
		"1280 x 648"  : Vector2i(1280, 648),
		"1920 x 1080" : Vector2i(1920, 1080),
		"3840 x 1600" : Vector2i(3840, 1600),
}


func _ready() -> void:
	setup_video_options()


func setup_video_options() -> void:
	# window mode
	for mode in WINDOW_MODES:
		%WindowModeOptionButton.add_item(mode)
	
	var current_mode := DisplayServer.window_get_mode()
	match current_mode:
		DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN:
			%WindowModeOptionButton.select(0)
			%ResolutionOptionButton.disabled = true
		
		DisplayServer.WINDOW_MODE_FULLSCREEN:
			%WindowModeOptionButton.select(1)
			%ResolutionOptionButton.disabled = true
		
		DisplayServer.WINDOW_MODE_WINDOWED:
			%WindowModeOptionButton.select(2)
	
	# resolution
	for resolution in RESOLUTIONS:
		%ResolutionOptionButton.add_item(resolution)


func _on_window_mode_option_button_item_selected(index: int) -> void:
	match index:
		0: # Fullscreen
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
			%ResolutionOptionButton.disabled = true
		
		1: # Borderless
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_FULLSCREEN)
			%ResolutionOptionButton.disabled = true
		
		2: # Window
			DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)
			%ResolutionOptionButton.disabled = false


func _on_resolution_option_button_item_selected(index: int) -> void:
	DisplayServer.window_set_size(RESOLUTIONS.values()[index])
