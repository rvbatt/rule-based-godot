extends AbstractMatch
class_name ObtainInfoMatch

@export_group("Obtain Information", "OI")
@export_enum("Property", "Method") var OI_access_type: int = 0
@export var OI_property: StringName
@export var OI_method: StringName
@export var OI_arguments: Dictionary # type -> value

func _build_prop_or_method(json_repr: Array, start_inOIx: int) -> void:
	# Auxilary function
	if json_repr.size() == start_inOIx + 1: # only property
		OI_access_type = 0
		OI_property = json_repr[start_inOIx]
		OI_method = ""
		OI_arguments = {}
	else:
		OI_access_type = 1
		OI_property = ""
		OI_method = json_repr[start_inOIx]
		OI_arguments = _eval_arguments(json_repr[start_inOIx + 1])

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
		return test_node.callv(OI_method, OI_arguments.values())
