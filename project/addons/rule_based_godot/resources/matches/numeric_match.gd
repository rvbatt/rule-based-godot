class_name NumericMatch
extends AbstractMatch

@export var test_node_path: NodePath
@export var property_or_method: StringName
@export var method_arguments: Dictionary
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
		test_number = test_node.callv(property_or_method, method_arguments.values())

	if test_number == null:
		print_debug("Invalid NumericMatch property or method")
		return false

	return (min_value <= test_number) and (test_number <= max_value)

func representation() -> String:
	# ["Numeric", min, max, node, property_method, arguments]
	var string = '["Numeric", '
	if min_value == -INF:
		string += '"inf", '
	else:
		string += str(min_value) + ', '
	if max_value == INF:
		string += '"inf", '
	else:
		string += str(max_value) + ', '

	string +=  '"' + str(test_node_path) + '", "' + property_or_method + '", {'
	var types = method_arguments.keys()
	if not types.is_empty():
		string += '"' + types[0] + '": "' + str(method_arguments[types[0]]) + '"'
		for i in range(1, types.size()):
			string += ', "' + types[i] + '": "' + \
					str(method_arguments[types[i]]) + '"'

	string += "}]"
	return string

func build_from_repr(representation: Array) -> void:
	# ["Numeric", min, max, node, property_method, arguments]
	var min = representation[1]
	if min is String and min == "-inf":
		min_value = -INF
	else:
		min_value = min

	var max = representation[2]
	if max is String and max == "inf":
		max_value = INF
	else:
		max_value = max

	test_node_path = NodePath(representation[3])
	property_or_method = representation[4]
	method_arguments = eval_arguments(representation[5])
