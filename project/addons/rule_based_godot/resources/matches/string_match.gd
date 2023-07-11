class_name StringMatch
extends VariableNodeMatch

@export var string_value: String
@export var property_or_method: StringName
@export var method_arguments: Dictionary #Type -> value

static func json_format() -> String:
	return '["String", "value", "?var|node", "property_or_method", {"types": "arguments"}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(
		["String", string_value, _var_or_path_string(),
		property_or_method, method_arguments]
	)

func build_from_repr(json_repr) -> void:
	# Follows json_format
	string_value = json_repr[1]
	_build_var_or_path(json_repr[2])
	property_or_method = json_repr[3]
	method_arguments = _eval_arguments(json_repr[4])

func _node_satisfies_match(test_node: Node) -> bool:
	if test_node == null:
		print_debug("Invalid node")

		return false

	var test_string = null
	if property_or_method in test_node:
		test_string = test_node.get(property_or_method)
	elif test_node.has_method(property_or_method):
		test_string = test_node.callv(property_or_method, method_arguments.values())

	if test_string == null:
		print_debug("Invalid StringMatch property or method")
	print(test_string + " == " + string_value)
	return test_string == string_value
