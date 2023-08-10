@tool
class_name CallMethodAction
extends AbstractAction

@export var method: StringName
@export var arguments: Array

func _init():
	action_id = "CallMethod"
	repr_vars = ["method", "arguments"]

func _result_from_agent(agent: Node, bindings: Dictionary) -> Variant:
	if agent.has_method(method):
		return agent.callv(method, arguments)
	print_debug("Invalid CallMethodAction method")
	return null
