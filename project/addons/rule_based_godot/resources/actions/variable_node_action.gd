extends AbstractAction
class_name VariableNodeAction

@export_group("Action Node", "AN")
@export var AN_is_wildcard: bool = false
@export var AN_identifier: StringName
@export_node_path var AN_path: NodePath

func _get_action_node(bindings: Dictionary) -> Node:
	if AN_is_wildcard:
		var bound_nodepaths = bindings.get(AN_identifier, [])
		if bound_nodepaths.is_empty():
			print_debug("No nodes to perform action")
			return null
		return bound_nodepaths[0]
	else:
		return _system_node.get_node(AN_path)

func _var_or_path_string() -> String:
	# Auxilary function
	return '?' + AN_identifier if AN_is_wildcard else AN_path

func _build_var_or_path(var_or_node: String) -> void:
	# Auxilary function
	if var_or_node.begins_with('?'):
		AN_is_wildcard = true
		AN_identifier = var_or_node.trim_prefix('?')
		AN_path = ^""
	else:
		AN_is_wildcard = false
		AN_identifier = ""
		AN_path = NodePath(var_or_node)
