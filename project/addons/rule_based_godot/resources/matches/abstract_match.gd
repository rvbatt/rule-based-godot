class_name AbstractMatch
extends RuleBasedResource
# Abstract class for condition components

var _target_node = true:
	set(value):
		_target_node = value
		notify_property_list_changed()

@export_group("Target Node", "TN")
var TN_is_wildcard: bool = false:
	set(value):
		TN_is_wildcard = value
		notify_property_list_changed()

var TN_identifier: StringName
var TN_path: NodePath

func _get_property_list():
	if not _target_node: return []

	var properties = [{
		"name": "TN_is_wildcard",
		"type": TYPE_BOOL,
		"usage": PROPERTY_USAGE_DEFAULT,
		"hint": PROPERTY_HINT_ENUM,
		"hint_string": "true, false"
	}]
	if TN_is_wildcard:
		properties.append(
			{
			"name": "TN_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "ID"
			}
		)
	else:
		properties.append(
			{
			"name": "TN_path",
			"type": TYPE_NODE_PATH,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_PATH_VALID_TYPES,
			"hint_string": "Node"
			}
		)
	return properties

func is_satisfied(bindings: Dictionary) -> bool:
	# Uses Template method
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

func _read_number(number: Variant) -> float:
	if number is String:
		if number == "inf": return INF
		elif number == "-inf": return -INF
	return float(number)

func _write_number(number: float) -> Variant:
	if number == INF: return "inf"
	elif number == -INF: return "-inf"
	else: return number
