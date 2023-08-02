@tool
class_name CallMethodAction
extends AbstractAction

@export var method: StringName
@export var arguments: Dictionary

static func json_format() -> String:
	return '["CallMethod", "?var|node", "method", {"types": "arguments"}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["CallMethod", _var_or_path_string(), method, arguments])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	method = json_repr[2]
	arguments = _eval_arguments(json_repr[3])

func trigger(bindings: Dictionary) -> Array[Variant]:
	var results: Array[Variant] = []
	for agent in _get_action_nodes(bindings):
		if agent.has_method(method):
			results.append(agent.callv(method, arguments.values()))
		else:
			print_debug("Invalid CallMethodAction method")
	return results
