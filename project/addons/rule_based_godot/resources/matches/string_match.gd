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
	method_arguments = eval_arguments(json_repr[4])

func is_satisfied(bindings: Dictionary) -> bool:
	if uni_is_wildcard:
		for child in _system_node.get_children(true):
			print(child.name)
			if _get_string_value(child) == string_value:
				print("Try to add binding")

				bindings[uni_identifier] = _system_node.get_path_to(child)
				return true
		return false

	var test_node = _system_node.get_node(uni_test_node_path)
	if test_node == null:
		print_debug("Invalid StringMatch node")
		return false
	return _get_string_value(test_node) == string_value

func _get_string_value(test_node: Node) -> Variant:
	var test_string = null

	if property_or_method in test_node:
		test_string = test_node.get(property_or_method)
	elif test_node.has_method(property_or_method):
		test_string = test_node.callv(property_or_method, method_arguments.values())

	if test_string == null:
		print_debug("Invalid StringMatch property or method")
	return test_string
