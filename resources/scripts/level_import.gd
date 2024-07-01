@tool # Needed so it runs in editor.
extends EditorScenePostImport


var _scene: Node


func _post_import(scene: Node) -> Node:
	_scene = scene
	
	var file := get_source_file()
	# Nebenprodukte überspringen
	if file.ends_with("fbx_Rest.fbx") or file.ends_with("fbx_Collection.fbx"):
		return null
	
	print_rich("Importiere: [b]%s[/b]" % [file])
	iterate(scene)
	return scene


func iterate(node: Node) -> void:
	if node == null:
		return
	
	if node is MeshInstance3D:
		if node.name.ends_with("-colbox"):
			handle_box_collider(node)
			return
		
		map_materials(node)
	
	for child in node.get_children():
		iterate(child)


func handle_box_collider(node: MeshInstance3D) -> void:
	print_rich("Custom Collider: [b]%s[/b]" % [node.name])
	
	var aabb := node.mesh.get_aabb()
	var box_pos := aabb.get_center()
	var box_size := aabb.size
	
	# generate static body
	var body := StaticBody3D.new()
	body.set_name("StaticBody3D")
	body.position = box_pos
	
	# generate collider
	var collider := CollisionShape3D.new()
	collider.set_name("BoxCollider")
	collider.shape = BoxShape3D.new()
	collider.shape.size = box_size
	
	# add body and collider to scene
	var parent := node.get_parent()
	add_child(parent, body)
	add_child(body, collider)
	
	# remove old mesh instance
	node.queue_free()


func map_materials(node: MeshInstance3D) -> void:
	for i in node.mesh.get_surface_count():
		var mat = node.mesh.surface_get_material(i)
		if mat.resource_name.is_empty():
			continue
		print_rich("Material: %s" % [mat.resource_name])
		var res = "res://assets/materials/%s.tres" % [mat.resource_name]
		
		# check if file exists
		if FileAccess.file_exists(res):
			var link_mat = ResourceLoader.load(res)
		
			node.mesh.surface_set_material(i, link_mat)
		else:
			print_rich("Material %s nicht im Projekt gefunden." % [mat.resource_name])


# Reihenfolge ist wichtig, immer von oben nach unten
func add_child(parent: Node, node: Node) -> void:
	parent.add_child(node)
	node.owner = _scene
