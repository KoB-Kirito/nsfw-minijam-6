class_name VolumeOption
extends HBoxContainer


@onready var bus_index: int = 0:
	set(value):
		bus_index = value
		%Label.text = AudioServer.get_bus_name(bus_index) + " Volume"
		%VolumeSlider.value = db_to_percent(AudioServer.get_bus_volume_db(bus_index))


func _on_volume_slider_value_changed(value: float) -> void:
	AudioServer.set_bus_volume_db(bus_index, percent_to_db(value))
	
	%PercentLabel.text = str(value) + "%"


func percent_to_db(percent: float) -> float:
	return linear_to_db(percent / 100.0)

func db_to_percent(db: float) -> float:
	return db_to_linear(db) * 100.0
