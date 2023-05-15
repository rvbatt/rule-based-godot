class_name Rule
extends Resource

@export var condition: AbstractMatch
@export var actions: Array[AbstractAction]

func set_system_node(system_node: Node) -> void:
	condition.set_system_node(system_node)
	for action in actions:
		action.set_system_node(system_node)

func trigger_actions():
	for action in actions:
		action.trigger()
