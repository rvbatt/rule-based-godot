extends Resource
class_name RuleBasedResource
# Abstract class for all resources used in defining a RuleList

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func resource_id() -> String:
	var source_code: String = get_script().source_code
	var start_index: int = source_code.find("class_name") + 11
	var length: int = \
			min(source_code.find("\n", start_index), source_code.find(" ", start_index)) \
			- start_index
	var id: String = source_code.substr(start_index, length)
	return id.trim_suffix("Match").trim_suffix("Action")

func exported_vars() -> Array[String]:
	var var_dicts = get_property_list().filter(
		func(class_dict):
			return class_dict["usage"] & PROPERTY_USAGE_DEFAULT != 0 and \
					class_dict["usage"] & PROPERTY_USAGE_SCRIPT_VARIABLE != 0
	)
	var export_vars: Array[String] = []
	for var_dict in var_dicts:
		export_vars.append(var_dict["name"])
	return export_vars

func json_format() -> String:
	# Abstract method
	push_error("Abstract method call")
	return ""

func to_json_repr() -> Variant:
	# Abstract method
	push_error("Abstract method call")
	return ""

func build_from_repr(json_repr) -> void:
	# Abstract method
	push_error("Abstract method call")

func _eval_arguments(arguments: Array) -> Array:
	return arguments.map(_eval_value)

func _eval_value(value: Variant) -> Variant:
	var expression = Expression.new()
	if expression.parse(value) != OK:
		push_error(expression.get_error_text())
		return null

	var result = expression.execute()
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return null

	return result

func _read_number(number: Variant) -> float:
	if number is String:
		if number == "inf": return INF
		elif number == "-inf": return -INF
	return float(number)

func _write_number(number: float) -> Variant:
	if number == INF: return "inf"
	elif number == -INF: return "-inf"
	else: return number
