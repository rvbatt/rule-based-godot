extends AbstractMatch
class_name VariableNodeMatch

@export_group("Test Node", "TN")
@export var TN_is_wildcard: bool = false
@export var TN_identifier: StringName
@export var TN_path: NodePath

@export_group("Data extraction", "DE")
@export_enum("Property", "Method") var DE_extraction_type: int = 0
@export var DE_property: StringName
@export var DE_method: StringName
@export var DE_arguments: Dictionary # type -> value

func is_satisfied(bindings: Dictionary) -> bool:
	# Overrides abstract method, applies Template Method
	if TN_is_wildcard:
		var candidates = bindings.get(TN_identifier) \
			if bindings.has(TN_identifier) \
			else _system_node.get_children(true)

		var valid_candidates := []
		for candidate in candidates:
			if _node_satisfies_match(candidate):
				valid_candidates.append(candidate)

		bindings[TN_identifier] = valid_candidates
		return not valid_candidates.is_empty()

	return _node_satisfies_match(_system_node.get_node(TN_path))

func _node_satisfies_match(test_node: Node) -> bool:
	# Abstract method
	push_error("Abstract Method Call")
	return false

func _build_var_or_path(var_or_node: String) -> void:
	# Auxilary function
	if var_or_node.begins_with('?'):
		TN_is_wildcard = true
		TN_identifier = var_or_node.trim_prefix('?')
		TN_path = ^""
	else:
		TN_is_wildcard = false
		TN_identifier = ""
		TN_path = NodePath(var_or_node)

func _var_or_path_string() -> String:
	# Auxilary function
	return '?' + TN_identifier if TN_is_wildcard else TN_path

func _build_prop_or_method(json_repr: Array, start_index: int) -> void:
	# Auxilary function
	if json_repr.size() == start_index + 1: # only property
		DE_extraction_type = 0
		DE_property = json_repr[start_index]
		DE_method = ""
		DE_arguments = {}
	else:
		DE_extraction_type = 1
		DE_property = ""
		DE_method = json_repr[start_index]
		DE_arguments = _eval_arguments(json_repr[start_index + 1])

func _prop_or_method_array() -> Array:
	# Auxilary function
	return [DE_property] \
		if DE_extraction_type == 0 \
		else [DE_method, DE_arguments]

func _get_test_value(test_node: Node) -> Variant:
	# Auxilary function
	if test_node == null:
		print_debug("Invalid node")
		return null

	if DE_extraction_type == 0: # Property
		if not DE_property in test_node:
			print_debug("Invalid property")
			return null
		return test_node.get(DE_property)
	else: # Method
		if not test_node.has_method(DE_method):
			print_debug("Invalid method")
			return null
		return test_node.callv(DE_method, DE_arguments.values())
