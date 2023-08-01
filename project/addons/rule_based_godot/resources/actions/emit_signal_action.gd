@tool
class_name EmitSignalAction
extends AbstractAction

@export var signal_name: StringName

static func json_format() -> String:
	return '["EmitSignal", "?var|node", "signal_name"]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["EmitSignal", _var_or_path_string(), signal_name])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	signal_name = json_repr[2]

func trigger(bindings: Dictionary) -> Array[Variant]:
	var results: Array[Variant] = []
	for emiter in _get_action_nodes(bindings):
		if not emiter.has_user_signal(signal_name):
			emiter.add_user_signal(signal_name)
		results.append(emiter.emit_signal(signal_name))
	return results
