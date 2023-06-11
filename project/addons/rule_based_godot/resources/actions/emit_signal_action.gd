class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

func setup(system_node: Node) -> void:
	_system_node = system_node
	_system_node.add_user_signal(signal_name)

func trigger() -> Variant:
	return _system_node.emit_signal(signal_name)

func representation() -> String:
	# ["Emit", signal]
	return '["Emit", "' + signal_name + '"]'

func build_from_repr(representation: Array) -> void:
	# ["Emit", signal]
	signal_name = representation[1]
