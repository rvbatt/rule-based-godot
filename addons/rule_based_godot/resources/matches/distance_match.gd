@tool
class_name DistanceMatch
extends VariableTargetMatch

@export_node_path var source_node_path
var _source_node: Node
@export var min_distance: float
@export var max_distance: float

@export var retrieve_distances: bool = false:
	set(value):
		retrieve_distances = value
		notify_property_list_changed()
		if value:
			notification(NOTIFICATION_RETRIEVE_DATA)
var variable_name: StringName

func _notification(what):
	if what == NOTIFICATION_WILDCARD_TARGET:
		retrieve_distances = false

func _get_property_list():
	var properties := []

	if retrieve_distances:
		properties.append(
			{
			"name": "variable_name",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": ""
			}
		)

	return properties

func setup(system_node: Node) -> void:
	super.setup(system_node)
	_source_node = system_node.get_node(source_node_path)

static func json_format() -> String:
	#TODO: include variable_name
	return '["Distance", min, max, "source_node", "?var|node"]'

func to_json_string() -> String:
	# Follows json_format
	#TODO: include variable_name
	return JSON.stringify(
		["Distance", _write_number(min_distance), _write_number(max_distance),
		source_node_path, _var_or_path_string()]
	)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	#TODO: include variable_name
	min_distance = _read_number(json_repr[1])
	max_distance = _read_number(json_repr[2])
	source_node_path = NodePath(json_repr[3])
	_build_var_or_path(json_repr[4])

func _node_satisfies_match(target_node: Node, bindings: Dictionary) -> bool:
	if _source_node == null or target_node == null:
		print_debug("Invalid node in DistanceMatch")
	
	var distance: float = _source_node.global_position.distance_to(target_node.global_position)
	if retrieve_distances:
		bindings[variable_name] = distance
	return (min_distance <= distance) and (distance <= max_distance)
