extends Node


@export_file("*.dtl") var timeline: String


func _ready() -> void:
	start_cutscene()


func start_cutscene() -> void:
	Dialogic.signal_event.connect(on_dialogic_signal)
	
	Dialogic.start(timeline)
	
	await Dialogic.timeline_ended
	
	Dialogic.signal_event.disconnect(on_dialogic_signal)


func on_dialogic_signal(key: Variant) -> void:
	#TODO
	match key:
		"intro_1":
			# Play animation: look left and right, down > exclamation mark
			pass
		
		"intro_2":
			# Play animation: lifting skirt, exclamation mark
			pass
