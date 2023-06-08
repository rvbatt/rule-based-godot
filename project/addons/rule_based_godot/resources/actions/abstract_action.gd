class_name AbstractAction
extends Resource

var _system_node: Node

func setup(system_node: Node) -> void:
	_system_node = system_node

func eval_type_and_value(typevalue: String) -> Array:
	# type_value is a String of form type:value
	var sep = typevalue.rfind(":")
	var type = typevalue.substr(0, sep)

	var expression = Expression.new()
	if expression.parse(typevalue.substr(sep + 1)) != OK:
		typevalue[sep] = "("
		typevalue += ")"
		if expression.parse(typevalue) != OK:
			typevalue[sep] = ""
			typevalue[typevalue.length()-1] = ""
			if expression.parse(typevalue) != OK:
				push_error("Parse Error: value in Action")

	var value = expression.execute()
	if expression.has_execute_failed():
		push_error("Execution Error: value in Action")

	return [type, value]

func trigger() -> Variant:
	# Abstract method
	push_error("AbstractAction.trigger()")
	return null

func representation() -> String:
	# Abstract method
	push_error("AbstractAction.representation()")
	return "AbstractAction"

func build_from_repr(representation: String) -> void:
	# Abstract method
	push_error("AbstractAction.build_from_repr(representation)")
