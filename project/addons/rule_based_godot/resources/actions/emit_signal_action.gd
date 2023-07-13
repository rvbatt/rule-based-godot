@tool
class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

static func json_format() -> String:
	return '["Emit Signal", "?var|node", signal_name"]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["Emit Signal", _var_or_path_string(), signal_name])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	signal_name = json_repr[2]

func trigger(bindings: Dictionary) -> Variant:
	var action_node = _get_action_node(bindings)
	if not action_node.has_user_signal(signal_name):
		action_node.add_user_signal(signal_name)
	return _system_node.emit_signal(signal_name)
