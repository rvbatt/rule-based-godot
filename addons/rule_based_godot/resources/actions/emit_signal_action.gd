@tool
class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

static func json_format() -> String:
	return '["EmitSignal", "?var|node", "signal"]'

func _init():
	action_id = "EmitSignal"
	repr_vars = ["signal_name"]

func _result_from_agent(agent: Node, bindings: Dictionary) -> Variant:
	if not agent.has_user_signal(signal_name):
		agent.add_user_signal(signal_name)
	return agent.emit_signal(signal_name)
