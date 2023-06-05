class_name ANDMatch
extends AbstractMatch

@export var subconditions: Array[AbstractMatch]

func setup(system_node: Node) -> void:
	for condition in subconditions:
		if condition == null: continue
		condition.setup(system_node)

func is_satisfied() -> bool:
	if subconditions.is_empty():
		print_debug("Empty ANDMatch")
		return false

	for condition in subconditions:
		if condition == null: continue
		if not condition.is_satisfied():
			return false

	return true
