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

func _init():
	action_id = "SetProperty"
	repr_vars = ["property_and_value"]

func _result_from_agent(agent: Node, bindings: Dictionary) -> Variant:
	if not _property in agent:
		print_debug("Invalid SetPropertyAction property")
		return null

	var value_to_set = _value
	if _value is String and _value.begins_with('?'):
		value_to_set = bindings.get(_value.trim_prefix('?'))
	agent.set(_property, value_to_set)
	return value_to_set
