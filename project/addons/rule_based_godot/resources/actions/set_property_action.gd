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

	var type_value = eval_type_and_value(setterproperty_typevalue[1])
	type = type_value[0]
	value = [type_value[1]]
