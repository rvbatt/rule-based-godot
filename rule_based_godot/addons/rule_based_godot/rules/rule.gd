class_name Rule
extends Resource

@export var condition: MatchInterface
@export var agent_path: NodePath
@export var action_or_property: StringName
@export var arguments: Array

func _init(condition = null, agent_path = "",
		action_or_property = "", arguments = []):
	self.condition = condition
	self.agent_path = agent_path
	self.action_or_property = action_or_property
	self.arguments = arguments

func trigger():
	var agent: Node = get_node(agent_path)
	if agent == null:
		print("Invalid Agent at " + str(self))
		return

	if agent.has_method(action_or_property):
		return agent.callv(action_or_property, arguments)
	elif action_or_property in agent:
		agent.set(action_or_property, arguments[0])
	else:
		print("Invalid Action or Property")
