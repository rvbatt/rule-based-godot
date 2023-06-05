class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

func setup(system_node: Node) -> void:
	_system_node = system_node
	_system_node.add_user_signal(signal_name)

func trigger():
	_system_node.emit_signal(signal_name)
