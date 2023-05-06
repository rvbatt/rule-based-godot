class_name StringMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var test_string_property: StringName
@export var string_value: String

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print_debug("Invalid StringMatch node")
		return false

	var test_string = test_node.get(test_string_property)
	if test_string == null:
		print_debug("Invalid StringMatch property")
		return false

	return test_string == string_value
