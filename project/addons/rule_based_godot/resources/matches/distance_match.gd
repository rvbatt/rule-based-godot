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
	
	var distance = first_node.global_position.distance_to(second_node.global_position)
	return (min_distance <= distance) and (distance <= max_distance)
	
