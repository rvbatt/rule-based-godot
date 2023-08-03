extends Resource
class_name RuleBasedResource
# Abstract class for all resources used in defining a RuleSet

var _system_node: Node

static func json_format() -> String:
	# Abstract method
	push_error("Abstract method call")
	return ""

func setup(system_node: Node) -> void:
	_system_node = system_node

func to_json_string() -> String:
	# Abstract method
	push_error("Abstract method call")
	return ""

func build_from_repr(json_repr) -> void:
	# Abstract method
	push_error("Abstract method call")

func _eval_arguments(type_to_value: Dictionary) -> Dictionary:
	# Dict of form {"types": "values"}
	for type in type_to_value.keys():
		type_to_value[type] = _eval_value(type, type_to_value[type])
	return type_to_value

func _eval_value(type: StringName, value: String) -> Variant:
	if type == "String": return value

	var expression = Expression.new()
	if expression.parse(value) != OK:
		if expression.parse(type + "(" + value + ")") != OK:
			if expression.parse(type + value) != OK:
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