@tool
class_name NumericMatch
extends ObtainInfoMatch

@export var min_value: float
@export var max_value: float

static func json_format() -> String:
	return '["Numeric", min, max, "?var|node", "property" | "method", {"types": "arguments"}]'

func to_json_string() -> String:
	# Follows json_format
	var array = ["Numeric", _write_number(min_value), _write_number(max_value), _var_or_path_string()]
	array.append_array(_prop_or_method_array())
	return JSON.stringify(array)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	min_value = _read_number(json_repr[1])
	max_value = _read_number(json_repr[2])
	_build_var_or_path(json_repr[3])
	_build_prop_or_method(json_repr,4)

func _node_satisfies_match(test_node: Node) -> bool:
	var test_number = _get_test_value(test_node)
	return (min_value <= test_number) and (test_number <= max_value)
