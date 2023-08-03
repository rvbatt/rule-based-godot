class_name ObtainInfoMatch
extends VariableTargetMatch

# Type 0 is just property
@export_group("Obtain Information", "OI")
@export_enum("Property", "Method") var OI_access_type: int = 0:
	set(value):
		OI_access_type = value
		notify_property_list_changed()
var OI_property: StringName
var OI_method: StringName
var OI_arguments: Array

func _get_property_list():
	var properties = []
	if OI_access_type == 0:
		properties.append(
			{
			"name": "OI_property",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_LOCALIZABLE_STRING,
			"hint_string": "%s" % TYPE_STRING_NAME
			}
		)
	else:
		properties.append_array([
			{
			"name": "OI_method",
			"type": TYPE_STRING_NAME,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_LOCALIZABLE_STRING,
			"hint_string": "%s" % TYPE_CALLABLE
			},
			{
			"name": "OI_arguments",
			"type": TYPE_ARRAY,
			"usage": PROPERTY_USAGE_DEFAULT,
			"hint": PROPERTY_HINT_NONE,
			"hint_string": ""
			},
		])

	return properties

func _build_prop_or_method(json_repr: Array, start_index: int) -> void:
	# Auxilary function
	if json_repr.size() == start_index + 1: # only property
		OI_access_type = 0
		OI_property = json_repr[start_index]
		OI_method = ""
		OI_arguments = []
	else:
		OI_access_type = 1
		OI_property = ""
		OI_method = json_repr[start_index]
		OI_arguments = _eval_arguments(json_repr[start_index + 1])

func _prop_or_method_array() -> Array:
	# Auxilary function
	return [OI_property] \
		if OI_access_type == 0 \
		else [OI_method, OI_arguments]

func _get_test_value(test_node: Node) -> Variant:
	# Auxilary function
	if test_node == null:
		print_debug("Invalid node")
		return null

	if OI_access_type == 0: # Property
		if not OI_property in test_node:
			print_debug("Invalid property")
			return null
		return test_node.get(OI_property)
	else: # Method
		if not test_node.has_method(OI_method):
			print_debug("Invalid method")
			return null
		return test_node.callv(OI_method, OI_arguments)
