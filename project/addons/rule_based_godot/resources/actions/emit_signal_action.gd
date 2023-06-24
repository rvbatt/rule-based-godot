class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

static func json_format() -> String:
	return '["Emit Signal", "signal_name"]'

func setup(system_node: Node) -> void:
	_system_node = system_node
	_system_node.add_user_signal(signal_name)

func to_json_string() -> String:
	# Follows json_format
	return '["Emit", "' + signal_name + '"]'

func build_from_repr(json_repr) -> void:
	# Follows json_format
	signal_name = json_repr[1]

func trigger() -> Variant:
	return _system_node.emit_signal(signal_name)
