@tool
class_name DistanceMatch
extends DatumMatch

@export_node_path var source_node_path: NodePath
var _source_node: Node
@export var min_distance: float
@export var max_distance: float

func _init():
	match_id = "Distance"
	repr_vars = ["min_distance", "max_distance", "source_node_path"]
	preset_node_path("source_node_path", "_source_node")

func _get_data(target_node: Node) -> Variant:
	if _source_node == null or target_node == null:
		print_debug("Invalid node in DistanceMatch")
		return null

	return _source_node.global_position.distance_to(target_node.global_position)

func _data_satisfies_match(data: Variant) -> bool:
	if not data is float or data is int: return false
	return (min_distance <= data) and (data <= max_distance)
