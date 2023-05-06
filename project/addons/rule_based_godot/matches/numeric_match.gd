class_name NumericMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var test_number_property: StringName
@export var min_value: float
@export var max_value: float

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print_debug("Invalid NumericMatch node")
		return false

	var test_number = test_node.get(test_number_property)
	if test_number == null:
		print_debug("Invalid NumericMatch property")
		return false

	return (min_value <= test_number) and (test_number <= max_value)
