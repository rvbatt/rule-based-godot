class_name DistanceMatch
extends AbstractMatch

@export_node_path("Node2D", "Node3D") var first_node_path
@export_node_path("Node2D", "Node3D") var second_node_path
@export var min_distance: float
@export var max_distance: float

static func json_format() -> String:
	return '["Distance", min, max, "first_node", "second_node"]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(
		["Distance", _write_number(min_distance), _write_number(max_distance),first_node_path
		, second_node_path]
	)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	min_distance = _read_number(json_repr[1])
	max_distance = _read_number(json_repr[2])
	first_node_path = NodePath(json_repr[3])
	second_node_path = NodePath(json_repr[4])

func is_satisfied(bindings: Dictionary) -> bool:
	var first_node = _system_node.get_node(first_node_path)
	var second_node = _system_node.get_node(second_node_path)
	
	if first_node == null or second_node == null:
		print_debug("Invalid node in DistanceMatch")
		return false
	
	var distance: float = first_node.global_position.distance_to(second_node.global_position)
	return (min_distance <= distance) and (distance <= max_distance)
