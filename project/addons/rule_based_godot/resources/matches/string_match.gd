
class_name StringMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var property_or_method: StringName
@export var method_arguments: Dictionary #Type -> value
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
		test_string = test_node.callv(property_or_method, method_arguments.values())

	if test_string == null:
		print_debug("Invalid StringMatch property or method")
		return false

	return test_string == string_value

func representation() -> String:
	# ["String", value, node, property_method, arguments]
	var string = '["String", "' + string_value + '", "' + str(test_node_path) + '", "' + \
			property_or_method + '", {'
	var types = method_arguments.keys()
	if not types.is_empty():
		string += '"' + types[0] + '": "' + str(method_arguments[types[0]]) + '"'
		for i in range(1, types.size()):
			string += ', "' + types[i] + '": "' + \
					str(method_arguments[types[i]]) + '"'

	string += "}]"
	return string

func build_from_repr(representation: Array) -> void:
	# ["String", value, node, property_method, arguments]
	string_value = representation[1]
	test_node_path = NodePath(representation[2])
	property_or_method = representation[3]
	method_arguments = eval_arguments(representation[4])
