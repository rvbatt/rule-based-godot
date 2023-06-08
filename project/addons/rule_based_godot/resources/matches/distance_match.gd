class_name DistanceMatch
extends AbstractMatch

@export_node_path("Node2D", "Node3D") var first_node_path
@export_node_path("Node2D", "Node3D") var second_node_path
@export var min_distance: float
@export var max_distance: float

func is_satisfied() -> bool:
	var first_node = _system_node.get_node(first_node_path)
	var second_node = _system_node.get_node(second_node_path)
	
	if first_node == null or second_node == null:
		print_debug("Invalid node in DistanceMatch")
		return false
	
	var distance: float = first_node.global_position.distance_to(second_node.global_position)
	return (min_distance <= distance) and (distance <= max_distance)

func representation() -> String:
	# min <= |first - second| <= max
	return str(min_distance) + " <= " + \
			"|" + str(first_node_path) + " - " + str(second_node_path) + "|" \
			+ " <= " + str(max_distance)

func build_from_repr(representation: String) -> void:
	var min_nodes_max = representation.split(" <= ")
	if min_nodes_max[0] == "-inf":
		min_distance = -INF
	else:
		min_distance = float(min_nodes_max[0])
	if min_nodes_max[2] == "inf":
		max_distance = INF
	else:
		max_distance = float(min_nodes_max[2])
	
	var first_second = \
			min_nodes_max[1].substr(1, min_nodes_max[1].length() - 2).split(" - ")
	first_node_path = NodePath(first_second[0])
	second_node_path = NodePath(first_second[1])
