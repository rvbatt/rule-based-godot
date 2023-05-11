class_name NumericMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var property_or_method: StringName
@export var method_arguments: Array
@export var min_value: float
@export var max_value: float

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print_debug("Invalid NumericMatch node")
		return false

	var test_number = null
	if property_or_method in test_node:
		test_number = test_node.get(property_or_method)
	elif test_node.has_method(property_or_method):
		test_number = test_node.callv(property_or_method, method_arguments)

	if test_number == null:
		print_debug("Invalid NumericMatch property or method")
		return false

	return (min_value <= test_number) and (test_number <= max_value)
