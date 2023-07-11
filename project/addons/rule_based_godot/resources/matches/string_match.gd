class_name StringMatch
extends AbstractMatch

@export_group("Test NodePath", "uni")
@export var uni_is_wildcard: bool = false
@export var uni_identifier: StringName
@export var uni_test_node_path: NodePath

@export var string_value: String
@export var property_or_method: StringName
@export var method_arguments: Dictionary #Type -> value

static func json_format() -> String:
	return '["String", "value", "?var|node", "property_or_method", {"types": "arguments"}]'

func to_json_string() -> String:
	# ["String", value, test_node, property_or_method, {types: arguments}]
	var var_or_path = '?' + uni_identifier if uni_is_wildcard else str(uni_test_node_path)
	return JSON.stringify(
		["String", string_value, var_or_path, property_or_method, method_arguments]
	)

func build_from_repr(json_repr) -> void:
	# ["String", value, test_node, property_or_method, {types: arguments}]
	string_value = json_repr[1]
	if json_repr[2].begins_with('?'):
		uni_is_wildcard = true
		uni_identifier = json_repr[2].trim_prefix('?')
		uni_test_node_path = ^"."
	else:
		uni_is_wildcard = false
		uni_identifier = ""
		uni_test_node_path = NodePath(json_repr[2])
	property_or_method = json_repr[3]
	method_arguments = _eval_arguments(json_repr[4])

func is_satisfied(bindings: Dictionary) -> bool:
	if uni_is_wildcard:
		var valid_candidates := []
		var candidates: Array
		if bindings.has(uni_identifier):
			candidates = bindings.get(uni_identifier)
		else:
			candidates = _system_node.get_children(true)

		for candidate in candidates:
			if _matches_string_value(candidate):
				valid_candidates.append(candidate)
		bindings[uni_identifier] = valid_candidates
		return not valid_candidates.is_empty()

	return _matches_string_value(_system_node.get_node(uni_test_node_path))

func _matches_string_value(test_node: Node) -> bool:
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
	print(test_string + " == " + string_value)
	return test_string == string_value
