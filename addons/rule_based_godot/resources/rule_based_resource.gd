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
