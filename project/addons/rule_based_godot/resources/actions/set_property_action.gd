class_name SetPropertyAction
extends AbstractAction

@export var setter_path: NodePath
@export var property: StringName
@export var type: StringName
@export var value: Array

func to_json_string() -> String:
	# ["Set", setter_node, property, type, value]
	return JSON.stringify(["Set", setter_path, property, type, value[0]])

func build_from_repr(json_repr) -> void:
	# ["Set", setter_node, property, type, value]
	setter_path = NodePath(json_repr[1])
	property = json_repr[2]
	type = json_repr[3]
	value = [eval_value(type, json_repr[4])]

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
