extends RuleBasedResource
class_name AbstractAction

@export_group("Action Node", "AN")
@export var AN_is_wildcard: bool = false:
	set(value):
		AN_is_wildcard = value
		notify_property_list_changed()

var AN_identifier: StringName
var AN_path: NodePath = ^"."

var _action_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node
	if not AN_is_wildcard:
		_action_node = system_node.get_node(AN_path)

func trigger(bindings: Dictionary) -> Array[Variant]:
	# Abstract method
	push_error("Abstract Method Call")
	return []

func _get_property_list():
	var properties := []

	if AN_is_wildcard:
		properties.append(
			{
			"name": "AN_identifier",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_TYPE_STRING,
			"hint_string": "ID"
			}
		)
	else:
		properties.append(
			{
			"name": "AN_path",
			"type": TYPE_NODE_PATH,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NODE_PATH_TO_EDITED_NODE,
			"hint_string": "Node"
			}
		)
	return properties

func _get_action_nodes(bindings: Dictionary) -> Array:
	if AN_is_wildcard:
		var bound_nodepaths: Array = bindings.get(AN_identifier, [])
		if bound_nodepaths.is_empty():
			print_debug("No nodes to perform action")
		return bound_nodepaths
	else:
		return [_action_node]

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
