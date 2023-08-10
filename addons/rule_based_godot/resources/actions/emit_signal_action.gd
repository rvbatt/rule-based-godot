@tool
class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName
@export var parameter_to_type: Dictionary = {}
@export var arguments: Array = [] # same order as dict

func _init():
	action_id = "EmitSignal"
	repr_vars = ["signal_name", "parameter_to_type", "arguments"]
	pre_add_signal("signal_name", "parameter_to_type")

func _result_from_agent(agent: Node, bindings: Dictionary) -> Variant:
	var args = arguments
	for i in range(args.size()):
		var arg = args[i]
		if arg is String and arg.begins_with('?'):
			args[i] = bindings.get(arg.trim_prefix('?'))

	if not agent.has_signal(signal_name):
		agent.add_user_signal(signal_name, signal_param_array(parameter_to_type))

	return agent.emit_signal(signal_name, args)
