class_name VariableTargetMatch
extends AbstractMatch
# Abstract class for condition components

@export_group("Target Node", "TN")
@export var TN_is_wildcard: bool = false:
	set(value):
		TN_is_wildcard = value
		notify_property_list_changed()

var TN_search_groups: PackedStringArray
var TN_identifier: StringName
var TN_path: NodePath

func _get_property_list():
	var properties := []

	if TN_is_wildcard:
		properties.append_array([
			{
			"name": "TN_search_groups",
			"type": TYPE_PACKED_STRING_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_LOCALIZABLE_STRING,
			"hint_string": "Groups"
			},
			{
			"name": "TN_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "ID"
			}
		])
	else:
		properties.append(
			{
			"name": "TN_path",
			"type": TYPE_NODE_PATH,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE,
			"hint_string": "Node"
			}
		)
	return properties

func is_satisfied(bindings: Dictionary) -> bool:
	# Uses Template method
	if TN_is_wildcard:
		var candidates = bindings.get(TN_identifier) \
			if bindings.has(TN_identifier) \
			else _get_candidates()

		var valid_candidates := []
		for candidate in candidates:
			if _node_satisfies_match(candidate):
				valid_candidates.append(candidate)

		bindings[TN_identifier] = valid_candidates
		return not valid_candidates.is_empty()

	return _node_satisfies_match(_system_node.get_node(TN_path))

func _is_in_search_groups(node: Node) -> bool:
	if TN_search_groups.is_empty(): return true

	for group in TN_search_groups:
		if node.is_in_group(group): return true

	return false

func _get_candidates() -> Array[Node]:
	# If no group is provided, default to descendants of system node
	if TN_search_groups.is_empty():
		return _system_node.get_children(true)

	var scene = _system_node.get_tree()
	var candidates: Array[Node] = []
	for group in TN_search_groups:
		candidates.append_array(scene.get_nodes_in_group(group))
	return candidates

func _node_satisfies_match(target_node: Node) -> bool:
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
