class_name AreaDetectionMatch
extends AbstractMatch

@export_node_path("Area2D", "Area3D") var area_path
@export var specific_colliders: Array[NodePath]

func is_satisfied() -> bool:
	var area = _system_node.get_node(area_path)
	if area == null:
		print_debug("Invalid CollisionCheckMatch area")
		return false

	if specific_colliders.is_empty():
		return area.has_overlapping_areas() or area.has_overlapping_bodies()

	for collider_path in specific_colliders:
		var collider = _system_node.get_node(collider_path)
		if collider == null: continue

		if (collider is Area2D or collider is Area3D) and \
			area.overlaps_area(collider):
			return true

		if (collider is PhysicsBody2D or collider is PhysicsBody3D or 
			collider is TileMap or collider is GridMap) \
			and area.overlaps_body(collider):
				return true

	return false

func representation() -> String:
	# ["Area", area, [colliders]]
	var string = '["Area", "' + str(area_path) + '", ['
	if not specific_colliders.is_empty():
		string += '"' + str(specific_colliders[0]) + '"'
		for i in range(1, specific_colliders.size()):
			string += ', "' + str(specific_colliders[i]) + '"'
	string += ']]'

	return string

func build_from_repr(representation: Array) -> void:
	# ["Area", area, [colliders]]
	area_path = representation[1]
	specific_colliders = []
	for collider in representation[2]:
		specific_colliders.append(NodePath(collider))
