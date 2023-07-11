class_name SetPropertyAction
extends VariableNodeAction

@export var property: StringName
@export var type_and_value: Dictionary

static func json_format() -> String:
	return '["Set Property", "?var|node", "property", {"type": "value"}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["Set", _var_or_path_string(), property, type_and_value])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	property = json_repr[2]
	type_and_value = _eval_arguments(json_repr[3])

func trigger(bindings: Dictionary) -> Variant:
	var setter = _get_action_node(bindings)
	if setter == null:
		print_debug("Invalid SetPropertyAction setter")
		return null

	if property in setter:
		var value = type_and_value.values()[0]
		setter.set(property, value)
		return value
	else:
		print_debug("Invalid SetPropertyAction property")
		return null
