@tool
class_name CallMethodAction
extends AbstractAction

@export var method := &""
@export var arguments := []

func _trigger_agent(agent: Node, bindings: Dictionary) -> Variant:
	if agent.has_method(method):
		var args =  arguments.duplicate(true)
		for i in range(len(args)):
			var arg = args[i]
			if arg is String and arg.begins_with('?'):
				args[i] = bindings.get(arg.trim_prefix('?'))
		return agent.callv(method, args)

	print_debug("Invalid CallMethodAction method")
	return null
