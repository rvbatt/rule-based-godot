class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

func setup(system_node: Node) -> void:
	_system_node = system_node
	_system_node.add_user_signal(signal_name)

func to_json_string() -> String:
	# ["Emit", signal_name]
	return '["Emit", "' + signal_name + '"]'

func build_from_repr(json_repr) -> void:
	# ["Emit", signal_name]
	signal_name = json_repr[1]

func trigger() -> Variant:
	return _system_node.emit_signal(signal_name)
