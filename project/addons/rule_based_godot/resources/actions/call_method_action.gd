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
	# Call agent.method(type:argument,...,type:argument)
	var string = "Call " + str(agent_path) + "." + method + "("
	var types = arguments.keys()
	if not types.is_empty():
		string += types[0] + ":" + str(arguments[types[0]])
		for i in range(1, types.size()):
			string += "," + types[i] + ":" + str(arguments[types[i]])

	string += ")"
	return string

func build_from_repr(representation: String) -> void:
	var agentmethod_arguments = representation.trim_prefix("Call ").split("(")
	var agentmethod = agentmethod_arguments[0]

	var sep = agentmethod.rfind(".")
	agent_path = NodePath(agentmethod.substr(0, sep))
	method = agentmethod.substr(sep + 1)

	arguments = {}
	var argument_strings = agentmethod_arguments[1].trim_suffix(")").\
			split(",", false)
	for typevalue_string in argument_strings:
		var type_value = eval_type_and_value(typevalue_string)
		arguments[type_value[0]] = type_value[1]
