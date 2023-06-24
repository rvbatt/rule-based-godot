class_name NumericMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var property_or_method: StringName
@export var method_arguments: Dictionary
@export var min_value: float
@export var max_value: float

static func json_format() -> String:
	return '["Numeric", min, max, "test_node", "property_or_method", {"types": "arguments"}]'

func to_json_string() -> String:
	# ["Numeric", min, max, test_node, property_or_method, {types: arguments}]
	var min = "-inf" if min_value == -INF else min_value
	var max = "inf" if max_value == INF else max_value
	return JSON.stringify(
		["Numeric", min, max, test_node_path, property_or_method, method_arguments]
	)

func build_from_repr(json_repr) -> void:
	# ["Numeric", min, max, test_node, property_or_method, {types: arguments}]
	var min = json_repr[1]
	if min is String and min == "-inf":
		min_value = -INF
	else:
		min_value = min

	var max = json_repr[2]
	if max is String and max == "inf":
		max_value = INF
	else:
		max_value = max

	test_node_path = NodePath(json_repr[3])
	property_or_method = json_repr[4]
	method_arguments = eval_arguments(json_repr[5])

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print_debug("Invalid NumericMatch node")
		return false

	var test_number = null
	if property_or_method in test_node:
		test_number = test_node.get(property_or_method)
	elif test_node.has_method(property_or_method):
		test_number = test_node.callv(property_or_method, method_arguments.values())

	if test_number == null:
		print_debug("Invalid NumericMatch property or method")
		return false

	return (min_value <= test_number) and (test_number <= max_value)
