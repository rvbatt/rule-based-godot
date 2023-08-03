@tool
class_name SetPropertyAction
extends AbstractAction

@export var property_and_value: Dictionary: # Singleton
	set(prop_to_val):
		property_and_value = prop_to_val
		if prop_to_val.is_empty(): return
		_property = prop_to_val.keys()[0]
		_value = prop_to_val[_property]
var _property: StringName
var _value: Variant

static func json_format() -> String:
	return '["SetProperty", "?var|node", {"property": "?var"|value}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["SetProperty", _var_or_path_string(),
			var_to_str(property_and_value)])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	property_and_value = str_to_var(json_repr[2])

func trigger(bindings: Dictionary) -> Array[Variant]:
	var results: Array[Variant] = []
	for setter in _get_action_nodes(bindings):
		if _property in setter:
			setter.set(_property, _value)
			results.append(_value)
		else:
			print_debug("Invalid SetPropertyAction property")
	return results
