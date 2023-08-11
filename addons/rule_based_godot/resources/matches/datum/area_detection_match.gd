@tool
class_name AreaDetectionMatch
extends DatumMatch

@export_node_path("Area2D", "Area3D") var area_path: NodePath
var _area # Area2D or Area3D
# Keep list of areas and bodies overllaping, because the get_overllaping_*
# methods are not updated immediately after objects have moved
var _overlapping := []

func _init():
	Data_Retrieval = false
	preset_node_path("area_path", "_area")
	pre_connect("_area", "area_entered", _add_overlapping)
	pre_connect("_area", "body_entered", _add_overlapping)

func _add_overlapping(entity: Variant) -> void:
	_overlapping.append(entity)

func _remove_overlapping(entity: Variant) -> void:
	_overlapping.erase(entity)

func _node_satisfies_match(target_node: Node, bindings: Dictionary) -> bool:
	if target_node == null:
		print_debug("Invalid Area Detection node")
		return false
	if tester_is_wildcard:
		# All the work is done selecting the candidates
		return true

	if (target_node is Area2D or target_node is Area3D) and \
		_area.overlaps_area(target_node):
		return true

	if (target_node is PhysicsBody2D or target_node is PhysicsBody3D or
		target_node is TileMap or target_node is GridMap) \
		and _area.overlaps_body(target_node):
			return true

	return false

func _get_candidates() -> Array:
	return _overlapping.filter(is_in_search_groups)
