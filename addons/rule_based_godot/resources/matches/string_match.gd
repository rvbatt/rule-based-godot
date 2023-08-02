@tool
class_name StringMatch
extends ObtainInfoMatch

@export var string_value: String

static func json_format() -> String:
	return '["String", "value", "?var|node", "property" | "method", {"types": "arguments"}]'

func to_json_string() -> String:
	# Follows json_format
	var array = ["String", string_value, _var_or_path_string()]
	array.append_array(_prop_or_method_array())
	return JSON.stringify(array)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	string_value = json_repr[1]
	_build_var_or_path(json_repr[2])
	_build_prop_or_method(json_repr,3)

func _node_satisfies_match(test_node: Node) -> bool:
	return _get_test_value(test_node) == string_value
