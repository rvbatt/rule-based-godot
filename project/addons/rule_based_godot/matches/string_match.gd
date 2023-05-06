class_name StringMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var property_or_method: StringName
@export var method_arguments: Array
@export var string_value: String

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print_debug("Invalid StringMatch node")
		return false

	var test_string = null
	if property_or_method in test_node:
		test_string = test_node.get(property_or_method)
	elif test_node.has_method(property_or_method):
		test_string = test_node.callv(property_or_method, method_arguments)

	if test_string == null:
		print_debug("Invalid StringMatch property or method")
		return false

	return test_string == string_value
	
