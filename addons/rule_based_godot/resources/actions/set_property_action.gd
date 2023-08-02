@tool
class_name SetPropertyAction
extends AbstractAction

@export var property: StringName
@export var type_and_value: Dictionary # Singleton {type: value}

static func json_format() -> String:
	return '["SetProperty", "?var|node", "property", {"type": "value"}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["SetProperty", _var_or_path_string(), property, type_and_value])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	property = json_repr[2]
	type_and_value = _eval_arguments(json_repr[3])

func trigger(bindings: Dictionary) -> Array[Variant]:
	var results: Array[Variant] = []
	for setter in _get_action_nodes(bindings):
		if property in setter:
			var value = type_and_value.values()[0] # Singleton
			setter.set(property, value)
			results.append(value)
		else:
			print_debug("Invalid SetPropertyAction property")
	return results
