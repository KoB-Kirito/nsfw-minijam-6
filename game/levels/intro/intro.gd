extends Node


@export var timeline: DialogicTimeline
@export_file("*.tscn") var next_scene: String
@export var next_bgm: AudioStream


func _ready() -> void:
	Dialogic.start(timeline)
	
	await Dialogic.timeline_ended
	
	var transition := SceneTransition.Options.new(next_scene)
	transition.duration = 4.0
	transition.new_bgm = next_bgm
	transition.volume = -8.0
	SceneTransition.change_scene(transition)
