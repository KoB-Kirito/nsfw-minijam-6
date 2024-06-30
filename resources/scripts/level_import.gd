@tool # Needed so it runs in editor.
extends EditorScenePostImport

func _post_import(scene):
	var file = get_source_file()
	print_rich("Importiere: [b]%s[/b]" % [file])
	iterate(scene, scene)
	return scene

func iterate(node, scene):
	if node != null:
		if node.name.ends_with("-colbox") and node is MeshInstance3D:
			handle_box_collider(node, scene)
		else:
			for child in node.get_children():
				iterate(child, scene)

func handle_box_collider(node: MeshInstance3D, scene):
	print_rich("Custom Collider: [b]%s[/b]" % [node.name])
	
	var aabb = (node as MeshInstance3D).mesh.get_aabb()
	var box_pos = aabb.get_center()
	var box_size = aabb.size
	var collider = CollisionShape3D.new()
	collider.set_name("BoxCollider")
	collider.shape = BoxShape3D.new()
	collider.shape.size = box_size
	
	var body = StaticBody3D.new()
	body.set_name("StaticBody3D")
	body.position = box_pos
	
	var parent = node.get_parent()
	body.add_child(collider)
	parent.add_child(body)
	body.owner = scene
	collider.owner = scene
	parent.remove_child(node)
	node.owner = null
