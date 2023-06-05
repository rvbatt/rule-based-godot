class_name Rule
extends Resource

@export var condition: AbstractMatch
@export var actions: Array[AbstractAction]

func setup(system_node: Node) -> void:
	condition.setup(system_node)
	for action in actions:
		action.setup(system_node)

func trigger_actions():
	for action in actions:
		action.trigger()
