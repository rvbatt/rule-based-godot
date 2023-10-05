@tool
class_name EmitSignalAction
extends AbstractAction

@export var signal_name := &""
@export var parameter_to_type := {}
@export var arguments := [] # same order as dict

func _init():
	_pre_add_signal("signal_name", "parameter_to_type")

func _trigger_node(agent_node: Node, bindings: Dictionary) -> Variant:
	var args = arguments
	for i in range(args.size()):
		var arg = args[i]
		if arg is String and arg.begins_with('?'):
			args[i] = bindings.get(arg.trim_prefix('?'))

	if not agent_node.has_signal(signal_name):
		agent_node.add_user_signal(signal_name, _signal_param_array(parameter_to_type))

	return agent_node.emit_signal(signal_name, args)
