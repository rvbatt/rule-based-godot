@tool
class_name DistanceMatch
extends AbstractMatch

@export_node_path("Node2D", "Node3D") var source_node_path

@export var min_distance: float
@export var max_distance: float

static func json_format() -> String:
	return '["Distance", min, max, "source_node", "?var|node"]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(
		["Distance", _write_number(min_distance), _write_number(max_distance),
		source_node_path, _var_or_path_string()]
	)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	min_distance = _read_number(json_repr[1])
	max_distance = _read_number(json_repr[2])
	source_node_path = NodePath(json_repr[3])
	_build_var_or_path(json_repr[4])

func _node_satisfies_match(target_node: Node) -> bool:
	var source_node = _system_node.get_node(source_node_path)
	if source_node == null or target_node == null:
		print_debug("Invalid node in DistanceMatch")
	
	var distance: float = source_node.global_position.distance_to(target_node.global_position)
	return (min_distance <= distance) and (distance <= max_distance)
