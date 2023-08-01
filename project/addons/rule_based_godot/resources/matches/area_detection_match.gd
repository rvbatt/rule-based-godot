@tool
class_name AreaDetectionMatch
extends VariableTargetMatch

@export_node_path("Area2D", "Area3D") var area_path
var _area # Area2D or Area3D
# Keep list of areas and bodies overllaping, because the get_overllaping_*
# methods are not updated immediately after objects have moved
var _overlapping := []
var _area_setup: bool = false

func _add_overlapping(entity: Variant) -> void:
	_overlapping.append(entity)

func _remove_overlapping(entity: Variant) -> void:
	_overlapping.erase(entity)

func _setup_area() -> void:
	_area = _system_node.get_node(area_path)
	if _area == null:
		print_debug("Invalid Area Detection area")
		return

	_area.area_entered.connect(_add_overlapping)
	_area.body_entered.connect(_add_overlapping)

	_area.area_exited.connect(_remove_overlapping)
	_area.body_exited.connect(_remove_overlapping)

	_area_setup = true

static func json_format() -> String:
	return '["AreaDetection", "area_node", ?var|"collider"]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["AreaDetection", area_path, _var_or_path_string()])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	area_path = json_repr[1]
	_build_var_or_path(json_repr[2])

func is_satisfied(bindings: Dictionary) -> bool:
	if not _area_setup: _setup_area()
	return super.is_satisfied(bindings)

func _node_satisfies_match(target_node: Node) -> bool:
	# All the work is done selecting the candidates
	return true

func _get_candidates() -> Array:
	return _overlapping.filter(_is_in_search_groups)
