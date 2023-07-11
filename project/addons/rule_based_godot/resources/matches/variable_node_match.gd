extends AbstractMatch
class_name VariableNodeMatch

@export_group("Test Node", "TN")
@export var TN_is_wildcard: bool = false
@export var TN_identifier: StringName
@export var TN_path: NodePath

func is_satisfied(bindings: Dictionary) -> bool:
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
	if var_or_node.begins_with('?'):
		TN_is_wildcard = true
		TN_identifier = var_or_node.trim_prefix('?')
		TN_path = ^""
	else:
		TN_is_wildcard = false
		TN_identifier = ""
		TN_path = NodePath(var_or_node)

func _var_or_path_string() -> String:
	return '?' + TN_identifier if TN_is_wildcard else TN_path
