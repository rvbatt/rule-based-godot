class_name CallMethodAction
extends AbstractAction

@export var agent_path: NodePath
@export var method: StringName
@export var arguments: Dictionary

func to_json_string() -> String:
	# ["Call", agent_node, method, {types: arguments}]
	return JSON.stringify(["Call", agent_path, method, arguments])

func build_from_repr(json_repr) -> void:
	# ["Call", agent_node, method, {types: arguments}]
	agent_path = NodePath(json_repr[1])
	method = json_repr[2]
	arguments = eval_arguments(json_repr[3])

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
