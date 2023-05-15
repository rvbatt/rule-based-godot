class_name CallMethodAction
extends AbstractAction

@export var agent_path: NodePath
@export var method: StringName
@export var arguments: Array

func trigger():
	var agent: Node = _system_node.get_node(agent_path)
	if agent == null:
		print_debug("Invalid CallMethodAction agent")
		return

	if agent.has_method(method):
		return agent.callv(method, arguments)
	else:
		print_debug("Invalid CallMethodAction method")
