@tool
class_name CallMethodAction
extends AbstractAction

@export var method: StringName = ""
@export var arguments: Array = []

func _trigger_agent(agent: Node, bindings: Dictionary) -> Variant:
	if agent.has_method(method):
		return agent.callv(method, arguments)
	print_debug("Invalid CallMethodAction method")
	return null
