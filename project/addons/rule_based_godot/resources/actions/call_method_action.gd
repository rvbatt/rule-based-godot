class_name CallMethodAction
extends AbstractAction

@export var agent_path: NodePath
@export var method: StringName
@export var arguments: Dictionary

func trigger() -> Variant:
	var agent: Node = _system_node.get_node(agent_path)
	if agent == null:
		print_debug("Invalid CallMethodAction agent")
		return null

	if agent.has_method(method):
		return agent.callv(method, arguments.values())
	else:
		print_debug("Invalid CallMethodAction method")
		return null

func representation() -> String:
	# ["Call", agent, method, {type: value}]
	var string = '["Call", "' + str(agent_path) + '", ' + method + "', {"
	var types = arguments.keys()
	if not types.is_empty():
		string += '"' + types[0] + '": "' + str(arguments[types[0]]) + '"'
		for i in range(1, types.size()):
			string += ', "' + types[i] + '": "' + str(arguments[types[i]]) + '"'

	string += "}]"
	return string

func build_from_repr(representation: Array) -> void:
	# ["Call", agent, method, {type: value}]
	agent_path = representation[1]
	method = representation[2]
	arguments = eval_arguments(representation[3]
