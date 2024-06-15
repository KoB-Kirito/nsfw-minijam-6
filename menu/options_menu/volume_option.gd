class_name VolumeOption
extends HBoxContainer


@export var demo_sound: AudioStream

@onready var bus_index: int = 0:
	set(value):
		bus_index = value
		%Label.text = AudioServer.get_bus_name(bus_index) + " Volume"
		%VolumeSlider.value = db_to_percent(AudioServer.get_bus_volume_db(bus_index))


func _ready() -> void:
	if not demo_sound:
		push_warning("No demo sound set for " + AudioServer.get_bus_name(bus_index))
		return
	
	%snd_demo.stream = demo_sound


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, percent_to_db(value))
	
	%PercentLabel.text = str(value) + "%"


func _on_volume_slider_drag_started() -> void:
	%snd_demo.play()

func _on_volume_slider_focus_exited() -> void:
	%snd_demo.stop()


func percent_to_db(percent: float) -> float:
	return linear_to_db(percent / 100.0)

func db_to_percent(db: float) -> float:
	return db_to_linear(db) * 100.0
