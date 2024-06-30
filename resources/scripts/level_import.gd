@tool # Needed so it runs in editor.
extends EditorScenePostImport

func _post_import(scene):
	iterate(scene)
	return scene # Remember to return the imported scene

func iterate(node):
	if node != null:
		if node.name.ends_with("-colbox") and node is MeshInstance3D:
			handle_box_collider(node)
		else:
			for child in node.get_children():
				iterate(child)

func handle_box_collider(node: MeshInstance3D):
	print_rich("Custom Collider: [b]%s[/b]" % [node.name])
	
	var box_size = (node as MeshInstance3D).mesh.get_aabb().size
	var collider = CollisionShape3D.new()
	collider.shape = BoxShape3D.new()
	collider.shape.size = box_size
	
	var parent = node.get_parent()
	parent.remove_child(node)
	node.free()
	var body = StaticBody3D.new()
	body.add_child(collider)
	parent.add_child(body)
	
