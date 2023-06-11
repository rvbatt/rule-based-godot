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
	# ["Distance", min, max, first, second]
	var string = '["Distance", '
	if  min_distance == -INF:
		string += '"-inf", '
	else:
		string += str(min_distance) + ', '
	if max_distance == INF:
		string += '"inf", '
	else:
		string += str(max_distance) + ', '
	return string + '"' + str(first_node_path) + '", "' + str(second_node_path) \
			+ '"]'

func build_from_repr(representation: Array) -> void:
	# ["Distance", min, max, first, second]
	var min = representation[1]
	if min is String and min == "-inf":
		min_distance = -INF
	else:
		min_distance = min

	var max = representation[2]
	if max is String and max == "inf":
		max_distance = INF
	else:
		max_distance = max

	first_node_path = NodePath(representation[3])
	second_node_path = NodePath(representation[4])
