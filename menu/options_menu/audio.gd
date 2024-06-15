extends TabBar


func _ready() -> void:
	setup_audio_options()


func setup_audio_options() -> void:
	# master volume
	%MasterVolumeOption.bus_index = 0
	
	# add other busses
	for bus_index in range(1, AudioServer.bus_count):
		var volume_option := %MasterVolumeOption.duplicate() as VolumeOption
		volume_option.name = AudioServer.get_bus_name(bus_index) + "VolumeOption"
		%VolumeSliderContainer.add_child(volume_option)
		volume_option.bus_index = bus_index
