@tool # Needed so it runs in editor.
extends EditorScenePostImport

var scene

func _post_import(scene):
	self.scene = scene
	var file = get_source_file()
	print_rich("Importiere: [b]%s[/b]" % [file])
	iterate(scene)
	return scene

func iterate(node):
	if node != null:
		if node.name.ends_with("-colbox") and node is MeshInstance3D:
			handle_box_collider(node)
		else:
			if node is MeshInstance3D:
				map_materials(node)
			for child in node.get_children():
				iterate(child)

func map_materials(node: MeshInstance3D):
	for i in range(node.mesh.get_surface_count()):
		var mat = node.mesh.surface_get_material(i)
		print_rich("Material: %s" % [mat.resource_name])

func handle_box_collider(node: MeshInstance3D):
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
	add_child(parent, body)
	add_child(body, collider)
	parent.remove_child(node)
	node.owner = null

# Reihenfolge ist wichtig, immer von oben nach unten
func add_child(parent, node):
	parent.add_child(node)
	node.owner = self.scene
