@tool
class_name SetPropertyAction
extends AbstractAction

@export var property_and_value := {}: # Singleton
	set(prop_to_val):
		if prop_to_val.size() != 1: return
		property_and_value = prop_to_val
		_property = prop_to_val.keys()[0]
		_value = prop_to_val[_property]
var _property := &""
var _value: Variant = null

func _trigger_node(agent_node: Node, bindings: Dictionary) -> Variant:
	if not _property in agent_node:
		print_debug("Invalid SetPropertyAction property")
		return null

	var value_to_set = _value
	if _value is String and _value.begins_with('?'):
		value_to_set = bindings.get(_value.trim_prefix('?'))
	agent_node.set(_property, value_to_set)
	return value_to_set
