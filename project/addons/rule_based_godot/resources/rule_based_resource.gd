extends Resource
class_name RuleBasedResource
# Abstract class for all resources used in defining a RuleSet

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func to_json_string() -> String:
	# Abstract method
	push_error("Abstract method call")
	return ""

func build_from_repr(json_repr) -> void:
	# Abstract method
	push_error("Abstract method call")

func eval_arguments(type_to_value: Dictionary) -> Dictionary:
	# Dict of form {"types": "values"}
	for type in type_to_value.keys():
		type_to_value[type] = eval_value(type, type_to_value[type])
	return type_to_value

func eval_value(type: StringName, value: String) -> Variant:
	var expression = Expression.new()
	if expression.parse(type + "(" + value + ")") != OK:
		if expression.parse(type + value) != OK:
			if expression.parse(value) != OK:
				push_error(expression.get_error_text())
				return null

	var result = expression.execute()
	if expression.has_execute_failed():
		push_error(expression.get_error_text())
		return null

	return result
