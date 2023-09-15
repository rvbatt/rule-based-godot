class_name RuleBasedResource
extends Resource
# Abstract class for all resources used in defining a RuleList

var _system_node: Node

func setup(system_node: Node) -> void:
	# Abstract method called when the RuleBasedSystem is ready
	_system_node = system_node

func json_format() -> String:
	# Returns the expected format for to_json_repr()
	push_error("Abstract method call")
	return ""

func to_json_repr() -> Variant:
	# Returns an Array or a Dictionary with an identification and
	# all needed variables
	push_error("Abstract method call")
	return ""

func build_from_repr(json_repr) -> void:
	# Receives the representation from to_json_repr() and
	# builds itself with its information
	push_error("Abstract method call")

func _resource_id() -> String:
	# The class_name without the suffix Action or Match
	var source_code: String = get_script().source_code
	var start_index: int = source_code.find("class_name") + 11
	var length: int = \
			min(source_code.find("\n", start_index), source_code.find(" ", start_index)) \
			- start_index
	var id: String = source_code.substr(start_index, length)
	return id.trim_suffix("Match").trim_suffix("Action")

func _exported_vars() -> Array[String]:
	var var_dicts = get_property_list().filter(
		func(class_dict):
			return class_dict["usage"] & PROPERTY_USAGE_DEFAULT != 0 and \
					class_dict["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0
	)
	var export_vars: Array[String] = []
	for var_dict in var_dicts:
		export_vars.append(var_dict["name"])
	return export_vars
