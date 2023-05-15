class_name SetPropertyAction
extends AbstractAction

@export var setter_path: NodePath
@export var property: StringName
@export var value: Array

func trigger():
	var setter: Node = _system_node.get_node(setter_path)
	if setter == null:
		print_debug("Invalid SetPropertyAction setter")
		return

	if property in setter:
		setter.set(property, value[0])
	else:
		print_debug("Invalid SetPropertyAction property")
