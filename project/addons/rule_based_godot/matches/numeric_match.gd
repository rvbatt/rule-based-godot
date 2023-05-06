class_name NumericMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var test_number_property: StringName
@export var min_value: float
@export var max_value: float

func _init(test_node_path = "", test_number_property = "",
		min_value = 0, max_value = 0):
	self.test_node_path = test_node_path
	self.test_number_property = test_number_property
	self.min_value = min_value
	self.max_value = max_value

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print("Invalid NumericMatch node at " + str(self))
		return false

	var test_number = test_node.get(test_number_property)
	if test_number == null:
		print("Invalid NumericMatch property at " + str(self))
		return false

	return (min_value <= test_number) and (test_number <= max_value)
