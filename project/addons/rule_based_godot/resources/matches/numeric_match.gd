class_name NumericMatch
extends VariableNodeMatch

@export var property_or_method: StringName
@export var method_arguments: Dictionary
@export var min_value: float
@export var max_value: float

static func json_format() -> String:
	return '["Numeric", min, max, "?var|node", "property_or_method", {"types": "arguments"}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(
		["Numeric", _write_number(min_value), _write_number(max_value), _var_or_path_string(),
		property_or_method, method_arguments]
	)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	min_value = _read_number(json_repr[1])
	max_value = _read_number(json_repr[2])
	_build_var_or_path(json_repr[3])
	property_or_method = json_repr[4]
	method_arguments = _eval_arguments(json_repr[5])

func _node_satisfies_match(test_node: Node) -> bool:
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
