class_name SetPropertyAction
extends AbstractAction

@export var setter_path: NodePath
@export var property: StringName
@export var type: StringName
@export var value: Array

func trigger() -> Variant:
	var setter: Node = _system_node.get_node(setter_path)
	if setter == null:
		print_debug("Invalid SetPropertyAction setter")
		return null

	if property in setter:
		setter.set(property, value[0])
		return value[0]
	else:
		print_debug("Invalid SetPropertyAction property")
		return null

func representation() -> String:
	# Set setter.property = type:value
	return "Set " + str(setter_path) + "." + property + \
			" = " + type + ":" + str(value[0])

func build_from_repr(representation: String) -> void:
	var setterproperty_typevalue = representation.trim_prefix("Set ").split(" = ")
	var setterproperty = setterproperty_typevalue[0]

	var sep = setterproperty.rfind(".")
	setter_path = NodePath(setterproperty.substr(0, sep))
	property = setterproperty.substr(sep + 1)

	var typevalue = setterproperty_typevalue[1]
	sep = typevalue.rfind(":")
	type = typevalue.substr(0, sep)

	var expression = Expression.new()
	if expression.parse(typevalue.substr(sep + 1)) != OK:
		typevalue[sep] = "("
		typevalue += ")"
		if expression.parse(typevalue) != OK:
			typevalue[sep] = ""
			typevalue[typevalue.length()-1] = ""
			if expression.parse(typevalue) != OK:
				push_error("Parse Error: value of SetPropertyAction")
				return

	var new_value = expression.execute()
	if expression.has_execute_failed():
		push_error("Execution Error: value of SetPropertyAction")
		return

	value = [new_value]
