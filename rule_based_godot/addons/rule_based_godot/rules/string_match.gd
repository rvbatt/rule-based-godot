class_name StringMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var test_string_property: StringName
@export var string_value: String

func _init(test_node_path = "", test_string_property = "",
		string_value = ""):
	self.test_node_path = test_node_path
	self.test_string_property = test_string_property
	self.string_value = string_value

func is_satisfied() -> bool:
	var test_node = _system_node.get_node(test_node_path)
	if test_node == null:
		print("Invalid StringMatch node at " + str(self))
		return false

	var test_string = test_node.get(test_string_property)
	if test_string == null:
		print("Invalid StringMatch property at " + str(self))
		return false

	return test_string == string_value
