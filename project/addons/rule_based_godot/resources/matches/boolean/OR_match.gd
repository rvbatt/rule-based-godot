class_name ORMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch]

func set_system_node(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.set_system_node(system_node)

func is_satisfied() -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if condition.is_satisfied():
			return true

	return false
