class_name SetPropertyAction
extends AbstractAction

@export_group("Test NodePath", "uni")
@export var uni_is_wildcard: bool = false
@export var uni_identifier: StringName
@export var uni_setter_path: NodePath

@export var property: StringName
@export var type: StringName
@export var value: Array

static func json_format() -> String:
	return '["Set Property", "?var|node", "property", "type", "value"]'

func to_json_string() -> String:
	# Follows json_format
	var var_or_path = '?' + uni_identifier if uni_is_wildcard else str(uni_setter_path)
	return JSON.stringify(["Set", var_or_path, property, type, value[0]])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	if json_repr[1].begins_with('?'):
		uni_is_wildcard = true
		uni_identifier = json_repr[1].trim_prefix('?')
		uni_setter_path = ^"."
	else:
		uni_is_wildcard = false
		uni_identifier = ""
		uni_setter_path = NodePath(json_repr[1])
	property = json_repr[2]
	type = json_repr[3]
	value = [_eval_value(type, json_repr[4])]

func trigger(bindings: Dictionary) -> Variant:
	var setter: Node
	if uni_is_wildcard:
		var bound_nodepaths = bindings.get(uni_identifier, [])
		if bound_nodepaths.is_empty():
			return null
		setter = bound_nodepaths[0]
	else:
		setter = _system_node.get_node(uni_setter_path)
	if setter == null:
		print_debug("Invalid SetPropertyAction setter")
		return null

	if property in setter:
		setter.set(property, value[0])
		return value[0]
	else:
		print_debug("Invalid SetPropertyAction property")
		return null
