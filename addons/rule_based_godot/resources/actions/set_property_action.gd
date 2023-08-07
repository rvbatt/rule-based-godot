@tool
class_name SetPropertyAction
extends AbstractAction

@export var property_and_value: Dictionary: # Singleton
	set(prop_to_val):
		property_and_value = prop_to_val
		if prop_to_val.is_empty(): return
		_property = prop_to_val.keys()[0] # Singleton
		_value = prop_to_val[_property]
var _property: StringName = ""
var _value: Variant = null

static func json_format() -> String:
	return '["SetProperty", "?var|node", {"property": "?var"|value}]'

func to_json_repr() -> Variant:
	# Follows json_format
	return ["SetProperty", _var_or_path_string(), var_to_str(property_and_value)]

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	property_and_value = str_to_var(json_repr[2])

func trigger(bindings: Dictionary) -> Array[Variant]:
	var results: Array[Variant] = []
	for setter in _get_action_nodes(bindings):
		if not _property in setter:
			print_debug("Invalid SetPropertyAction property")
			continue

		var value_to_set = _value
		if _value is String and _value.begins_with('?'):
			value_to_set = bindings.get(_value.trim_prefix('?'))
		setter.set(_property, value_to_set)
		results.append(value_to_set)

	return results
