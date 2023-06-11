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
	# ['Set', setter, property, type, value]
	return '["Set", "' + str(setter_path) + '", "' + property + \
			'", "' + type + '", "' + str(value[0]) + '"]'

func build_from_repr(representation: Array) -> void:
	# ['Set', setter, property, type, value]
	setter_path = NodePath(representation[1])
	property = representation[2]
	type = representation[3]
	value = [eval_value(type, representation[4])]
