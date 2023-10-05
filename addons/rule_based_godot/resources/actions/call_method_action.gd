@tool
class_name CallMethodAction
extends AbstractAction

@export var method := &""
@export var arguments := []

func _trigger_node(agent_node: Node, bindings: Dictionary) -> Variant:
	if agent_node.has_method(method):
		return agent_node.callv(method, arguments)
	print_debug("Invalid CallMethodAction method")
	return null
