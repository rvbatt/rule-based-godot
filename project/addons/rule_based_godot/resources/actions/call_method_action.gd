@tool
class_name CallMethodAction
extends AbstractAction

@export var method: StringName
@export var arguments: Dictionary

static func json_format() -> String:
	return '["Call Method", "?var|node", "method", {"types": "arguments"}]'

func to_json_string() -> String:
	# Follows json_format
	return JSON.stringify(["Call Method", _var_or_path_string(), method, arguments])

func build_from_repr(json_repr) -> void:
	# Follows json_format
	_build_var_or_path(json_repr[1])
	method = json_repr[2]
	arguments = _eval_arguments(json_repr[3])

func trigger(bindings: Dictionary) -> Variant:
	var agent = _get_action_node(bindings)
	if agent == null:
		print_debug("Invalid CallMethodAction agent")
		return null

	if agent.has_method(method):
		return agent.callv(method, arguments.values())
	else:
		print_debug("Invalid CallMethodAction method")
		return null
