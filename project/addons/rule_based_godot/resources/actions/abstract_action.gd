class_name AbstractAction
extends Resource

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func eval_arguments(type_to_value: Dictionary) -> Dictionary:
	var arguments = type_to_value.duplicate()
	for type in arguments.keys():
		arguments[type] = eval_value(type, arguments[type])
	return arguments

func eval_value(type: StringName, value: String) -> Variant:
	var expression = Expression.new()
	if expression.parse(type + "(" + value + ")") != OK:
		if expression.parse(type + value) != OK:
			if expression.parse(value) != OK:
				push_error("Parse Error: value in Action")

	var result = expression.execute()
	if expression.has_execute_failed():
		push_error("Execution Error: value in Action")

	return result

func trigger() -> Variant:
	# Abstract method
	push_error("AbstractAction.trigger()")
	return null

func representation() -> String:
	# Abstract method
	push_error("AbstractAction.representation()")
	return "AbstractAction"

func build_from_repr(representation: Array) -> void:
	# Abstract method
	push_error("AbstractAction.build_from_repr(representation)")
