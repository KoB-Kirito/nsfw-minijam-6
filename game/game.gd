extends Node3D
# Level loading logic


## Fake loading time
const MIN_LOADING_FRAMES = 100.0

@export_file("*.tscn") var first_level_path: String

var current_level: Node

var loading: bool
var loading_level_path: String
var loading_frame: float


func _ready() -> void:
	# load first level
	change_level(first_level_path)


func change_level(new_level_path: String) -> void:
	print_debug("Level change requested to: ", new_level_path)
	
	# pause game
	get_tree().paused = true
	
	#TODO: fade in
	%Fade.show()
	
	# unload current level
	if current_level:
		current_level.queue_free()
		await current_level.tree_exited
		current_level = null
	
	# load new level
	loading_level_path = new_level_path
	var level_packed = ResourceLoader.load_threaded_request(new_level_path, "", false, ResourceLoader.CACHE_MODE_REPLACE)
	
	# enable loading screen update
	loading = true
	loading_frame = 0


func _process(delta: float) -> void:
	if not loading:
		return
	
	var progress: Array = []
	var result := ResourceLoader.load_threaded_get_status(loading_level_path, progress)
	
	# update loading bar
	loading_frame += 1
	printt(progress[0], loading_frame / MIN_LOADING_FRAMES)
	%LoadingProgressBar.value = progress[0] * 50.0 + loading_frame / MIN_LOADING_FRAMES * 50.0
	
	# wait for fake loading
	if loading_frame < MIN_LOADING_FRAMES:
		return
	
	match result:
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_IN_PROGRESS:
			# keep loading
			pass
			
		ResourceLoader.ThreadLoadStatus.THREAD_LOAD_LOADED:
			loading = false
			instantiate_level()
			
		_:
			# crash
			assert(false, "Loading level failed [" + str(result) + "]: " + loading_level_path)
	



func instantiate_level() -> void:
	# instantiate
	var packed_level: PackedScene = ResourceLoader.load_threaded_get(loading_level_path)
	current_level = packed_level.instantiate()
	add_child(current_level)
	
	# connect level changes
	for level_change: LevelChange in get_tree().get_nodes_in_group("level_change"):
		level_change.change_level.connect(change_level.bind(level_change.level_path))
		print_debug("level change connected")
	
	# position player
	var start_position: Node3D = get_tree().get_first_node_in_group("start_position")
	if start_position:
		%Player.position = start_position.position
	else:
		push_warning("No start_position found. Setting player to 0,0,0")
		%Player. position = Vector3.ZERO
	
	#TODO: fade out
	%Fade.hide()
	
	get_tree().paused = false
