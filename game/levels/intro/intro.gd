extends Node


@export var timeline: DialogicTimeline
@export_file("*.tscn") var next_scene: String


func _ready() -> void:
	Dialogic.start(timeline)
	
	await Dialogic.timeline_ended
	
	var transition := SceneTransition.Options.new(next_scene)
	SceneTransition.change_scene(transition)
