class_name NumericMatch
extends AbstractMatch

@export_group("Test Node Path", "uni")
@export var uni_is_wildcard: bool = false
@export var uni_test_node_path: NodePath
@export var uni_identifier: StringName

@export var property_or_method: StringName
@export var method_arguments: Dictionary
@export var min_value: float
@export var max_value: float

static func json_format() -> String:
	return '["Numeric", min, max, "?var|node", "property_or_method", {"types": "arguments"}]'

func to_json_string() -> String:
	# ["Numeric", min, max, test_node, property_or_method, {types: arguments}]
	var min = "-inf" if min_value == -INF else min_value
	var max = "inf" if max_value == INF else max_value
	var var_or_path = '?' + uni_identifier if uni_is_wildcard else uni_test_node_path
	return JSON.stringify(
		["Numeric", min, max, var_or_path, property_or_method, method_arguments]
	)

func build_from_repr(json_repr) -> void:
	# ["Numeric", min, max, test_node, property_or_method, {types: arguments}]
	var min = json_repr[1]
	if min is String and min == "-inf":
		min_value = -INF
	else:
		min_value = min

	var max = json_repr[2]
	if max is String and max == "inf":
		max_value = INF
	else:
		max_value = max

	if json_repr[3].begins_with('?'):
		uni_is_wildcard = true
		uni_identifier = json_repr[3].trim_prefix('?')
		uni_test_node_path = ^""
	else:
		uni_is_wildcard = false
		uni_identifier = ""
		uni_test_node_path = NodePath(json_repr[3])

	property_or_method = json_repr[4]
	method_arguments = _eval_arguments(json_repr[5])

func is_satisfied(bindings: Dictionary) -> bool:
	if uni_is_wildcard:
		var valid_candidates := []
		var candidates: Array
		if bindings.has(uni_identifier):
			candidates = bindings.get(uni_identifier)
		else:
			candidates = _system_node.get_children(true)

		for candidate in candidates:
			if _number_in_interval(candidate):
				valid_candidates.append(candidate)
		bindings[uni_identifier] = valid_candidates
		return not valid_candidates.is_empty()

	return _number_in_interval(_system_node.get_node(uni_test_node_path))

func _number_in_interval(test_node: Node) -> bool:
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
