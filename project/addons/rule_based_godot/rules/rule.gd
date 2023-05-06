class_name Rule
extends Resource

@export var condition: AbstractMatch
@export var agent_path: NodePath
@export var property_or_method: StringName
@export var arguments: Array

var _system_node: Node

func set_system_node(system_node: Node) -> void:
	_system_node = system_node
	condition.set_system_node(system_node)

func trigger():
	var agent: Node = _system_node.get_node(agent_path)
	if agent == null:
		print_debug("Invalid Rule agent")
		return

	if property_or_method in agent:
		agent.set(property_or_method, arguments[0])
	elif agent.has_method(property_or_method):
		return agent.callv(property_or_method, arguments)
	else:
		print_debug("Invalid Rule action or property")
