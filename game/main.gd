extends Node3D

@onready var isFullscreen: bool = DisplayServer.window_get_mode()

var _ambSound : AudioStream = preload("res://assets/audio/bgm/wind-outside-sound-ambient-141989.mp3")


func fullscreenToggle() -> void:
	isFullscreen = !isFullscreen
	if isFullscreen:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_EXCLUSIVE_FULLSCREEN)
	else:
		DisplayServer.window_set_mode(DisplayServer.WINDOW_MODE_WINDOWED)


func _ready():
	# Capture the mouse (make it invisible)
	Input.set_mouse_mode(Input.MOUSE_MODE_CAPTURED)
	
	# Start playing ambience track
	#TODO: Music
	#SoundManager.play_music(_ambSound, 1.0, "Music")
